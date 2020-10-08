extends Node

const rakugo_version := "2.1.06"
const credits_path := "res://addons/Rakugo/credits.txt"
const save_folder := "saves"

# project settings integration
onready var game_title : String = ProjectSettings.get_setting("application/config/name")
onready var game_version : String = ProjectSettings.get_setting("rakugo/game/version")
onready var game_credits : String = ProjectSettings.get_setting("rakugo/game/credits")
onready var markup : String = ProjectSettings.get_setting("rakugo/gui/markup")
onready var debug_on : bool = ProjectSettings.get_setting("rakugo/editor/debug")
onready var test_save : bool = ProjectSettings.get_setting("rakugo/editor/test_saves")
onready var scene_links : String = ProjectSettings.get_setting("rakugo/game/scene_links")
onready var theme : RakugoTheme = load(ProjectSettings.get_setting("rakugo/gui/theme"))

# init vars for settings
var _skip_all_text := false#TODO update those with once the new parameters system is made
var _skip_after_choices := false
var _auto_time := 1
var _text_time := 0.3
var _notify_time := 3
var _typing_text := true

# this must be saved
var history_id := 0 setget _set_history_id, _get_history_id

var current_scene_name := ""
var current_dialogue:Node = null

# this store log of all dialogue up this point in current game
# {["scene_id", "dialogue_name", "event_name", story_step]:{"type":type, "parameters": parameters}}
var history := {}

# this store log of all dialogue that player saw
var global_history := {}

var store = null setget set_current_store, get_current_store 

# don't save this
onready var menu_node: = $Statements/Menu
var viewport : Viewport
#var loading_screen : Control
var current_scene_path := ""
var current_scene_node: Node = null
var current_statement: Statement = null

var active := false
var can_alphanumeric := true
var emoji_size := 16

var can_save := true

var file := File.new()
var loading_in_progress := false
var started := false

var auto_stepping := false
var skipping := false
var stepping_blocked = false

# timers use by rakugo
onready var auto_timer := $AutoTimer
onready var skip_timer := $SkipTimer
onready var notify_timer := $NotifyTimer

onready var SceneLoader: = $SceneLoader
onready var StoreManager: = $StoreManager
onready var ShowableManager: = $ShowableManager
onready var Say = $Statements/Say
onready var Ask = $Statements/Ask
onready var Menu = $Statements/Menu

signal say(character, text, parameters)
signal ask(variable_name, parameters)
signal menu(choices, parameters)
signal menu_return(result)
#TODO clean those
signal started()
signal begin()#TODO Looks redundant with started, look into it
signal story_step(dialogue_name, event_name)
signal checkpoint()
signal game_ended()
#TODO assert the need of those
signal notified()
signal hide_ui(value)
#TODO prune those
signal play_anim(node_id, anim_name)
signal stop_anim(node_id, reset)
signal play_audio(node_id, from_pos)
signal stop_audio(node_id)

func _ready() -> void:

	StoreManager.init()

	# set by game developer
	#define("title", game_title, false)
	#define("version", game_version, false)
	OS.set_window_title(game_title + " " + game_version)
	#define("credits", game_credits, false)

	# it must be before define rakugo_version and godot_version to parse corretly :o
	file.open(credits_path, file.READ)
	#define("rakugo_credits", file.get_as_text(), false)
	file.close()

	# set by rakugo
	#define("rakugo_version", rakugo_version, true)

	var gdv = Engine.get_version_info()
	var gdv_string = str(gdv.major) + "." + str(gdv.minor) + "." + str(gdv.patch)

## Rakugo flow control


# it starts Rakugo
func start(after_load := false) -> void:
	load_global_history()
	history_id = 0
	started = true

	if not after_load:
		emit_signal("started")


func save_game(save_name := "quick") -> bool:
	debug(["save data to :", save_name])
	return StoreManager.save_store_stack(save_name)


func load_game(save_name := "quick") -> bool:
	return StoreManager.load_store_stack(save_name)


func rollback(amount=1):
	self.unblock_stepping()
	self.StoreManager.change_current_stack_index(self.StoreManager.current_store_id + amount)


func activate_skipping():
	self.skipping = true
	skip_timer.start()

func deactivate_skipping():
	self.skipping = false


func activate_auto_stepping():
	self.auto_stepping = true
	auto_timer.start()

func deactivate_auto_stepping():
	self.auto_stepping = false


func prepare_quitting():
	if self.started:
		self.save_game("auto")
		self.save_global_history()

	settings.save_conf()


func load_scene(scene_id: String, force_reload:bool = false) -> void:
	SceneLoader.load_scene(scene_id, force_reload)

func clean_viewport():
	for c in self.viewport.get_children():
		self.viewport.remove_child(c)

func end_game() -> void:
	if current_scene_node != null:
		if current_scene_node.get_parent():
			current_scene_node.get_parent().remove_child(current_scene_node)
		current_scene_node.queue_free()

	var start_scene = ProjectSettings.get_setting("application/run/main_scene")
	var lscene = load(start_scene)
	current_scene_node = lscene.instance()
	exit_dialogue()
	get_tree().get_root().add_child(current_scene_node)
	started = false
	history.clear()
	history_id = 0
	emit_signal("game_ended")


# use this to assign beginning scene and dialogue
# root of path_to_current_scene is scenes_dir
# provide path_to_current_scene with out ".tscn"
func on_begin(path_to_current_scene: String, dialogue_name: String, event_name: String) -> void:
	if loading_in_progress:
		return

	var resource = load(scene_links).get_as_dict()
	debug([resource, path_to_current_scene])
	var path = resource[path_to_current_scene]

	if path is PackedScene:
		current_scene_path = path.resource_path
	else:
		current_scene_path = path

	jump(path_to_current_scene, dialogue_name , event_name)

# use this to change/assign current scene and dialogue
# id_of_current_scene is id to scene defined in scene_links or full path to scene
func jump(scene_id: String, dialogue_name: String, event_name: String, force_reload:bool = false) -> void:
	$Statements/Jump.invoke(scene_id, dialogue_name, event_name, force_reload)

## Dialogue flow control
func block_stepping():
	stepping_blocked = true

func unblock_stepping():
	stepping_blocked = false

func story_step(_unblock=false) -> void:
	if stepping_blocked and _unblock:
		stepping_blocked = false
	if not stepping_blocked:
		StoreManager.stack_next_store()
		print("emitting _step")
		get_tree().get_root().propagate_call('_step')
		#emit_signal("story_step", current_dialogue_name, current_event_name)



func exit_dialogue() -> void:
	if self.current_dialogue:
		self.current_dialogue.exit()




## Signal Emission


func exec_statement(type: int, parameters := {}) -> void:
	emit_signal("exec_statement", type, parameters)


func exit_statement(parameters := {}) -> void:
	emit_signal("exit_statement", current_statement.type, parameters)


func notified() -> void:
	emit_signal("notified")


func on_play_anim(node_id: String, anim_name: String) -> void:
	emit_signal("play_anim", node_id, anim_name)


func on_stop_anim(node_id: String, reset: bool) -> void:
	emit_signal("stop_anim", node_id, reset)


func on_play_audio(node_id: String, from_pos: float) -> void:
	emit_signal("play_audio", node_id, from_pos)


func on_stop_audio(node_id: String) -> void:
	emit_signal("stop_audio", node_id)




## Global history


func _set_history_id(value: int) -> void:
	history_id = value


func _get_history_id() -> int:
	return history_id


func is_current_statement_in_global_history() -> bool:
	return true
	if not current_statement.parameters.add_to_history:
		return true

	var id = current_statement.get_history_id()
	var c_item = current_statement.get_as_history_item()

	if global_history.has(id):
		var type = c_item.type
		var parameters = c_item.parameters

		if type == global_history[id].type:
			var hi_parameters = global_history[id].parameters

			if parameters.size() == hi_parameters.size():
				var keys = parameters.keys()
				var hi_keys = hi_parameters.keys()

				for i in range(parameters.size()):
					var p = parameters[keys[i]]
					var hi_p = hi_parameters[hi_keys[i]]

					if p != hi_p:
						return false

	return true


func can_qload() -> bool:
	return is_save_exits("quick")


func is_save_exits(save_name: String) -> bool:
	loading_in_progress = true
	var save_folder_path = "user://".plus_file(save_folder)

	if test_save:
		save_folder_path = "res://".plus_file(save_folder)

	var save_file_path = save_folder_path.plus_file(save_name)
	save_file_path += ".tres"

	return file.file_exists(save_file_path)


func save_global_history() -> bool:
	return $SaveGlobalHistory.invoke()


func load_global_history() -> bool:
	return $LoadGlobalHistory.invoke()


## Utils

# parse text like in renpy to bbcode if mode == "renpy"
# or parse bbcode with {vars} if mode == "bbcode"
# default mode = Rakugo.markup
func text_parser(text: String, mode := markup):
	var links_color := Color.aqua.to_html()
	if theme:
		links_color = theme.links_color.to_html() 
	
	return text#TextParser.text_parser(text, variables, mode, links_color)#TODO 


# returns exiting Rakugo variable as one of RakugoTypes for easy use
# It must be with out returned type, because we can't set it as list of types
func get_var(var_name: String):
	return get_current_store().get(var_name)


# just faster way to connect signal to rakugo's variable
func connect_var(
		var_name: String, signal_name: String,
		node: Object, func_name: String,
		binds := [], flags := 0
		) -> void:

	get_var(var_name).connect(
		signal_name, node, func_name,
		binds, flags
	)


# crate new character as global variable that Rakugo will see
# possible parameters: name, color, prefix, suffix, avatar, stats
func define_character(character_name: String, character_tag: String, parameters := {}) -> Character:
	var new_character := Character.new(character_name, character_tag, parameters)
	StoreManager.get_current_store()[character_tag] = new_character
	return new_character


# statement of type say
# its make given 'character' say 'text'
# 'parameters' keywords:typing, type_speed, avatar, avatar_state, add
# speed is time to show next letter
func say(character, text:String, parameters: Dictionary) -> void:
	Say.exec(character, text, parameters)


# statement of type ask
# with keywords: placeholder
# speed is time to show next letter
func ask(variable_name:String, parameters: Dictionary) -> void:
	Ask.exec(variable_name, parameters)


# statement of type menu
func menu(choices:Array, parameters: Dictionary) -> void:
	Menu.exec(choices, parameters)


# it show nod tagged with "showable <space separated tag>"
func show(showable_tag:String, parameters := {}):
	ShowableManager.show(showable_tag, parameters)


# statement of type hide
func hide(showable_tag: String) -> void:
	ShowableManager.hide(showable_tag)


# statement of type notify
#func notify(info: String, length: int = get_value("notify_time")) -> void:
#	var parameters = {
#		"info": info,
#		"length":length
#	}
#	_set_statement($Statements/Notify, parameters)
#	notify_timer.wait_time = parameters.length
#	notify_timer.start()


# statement of type play_anim
# it will play animation with anim_name form RakugoAnimPlayer with given node_id
func play_anim(node_id: String, anim_name: String) -> void:
	var parameters = {
		"node_id":node_id,
		"anim_name":anim_name
	}

	#_set_statement($Statements/PlayAnim, parameters)


# statement of type stop_anim
# it will stop animation form RakugoAnimPlayer with given node_id
# and by default is reset to 0 pos on exit from statment
func stop_anim(node_id: String, reset := true) -> void:
	var parameters = {
		"node_id":node_id,
		"reset":reset
	}

	#_set_statement($Statements/StopAnim, parameters)


# statement of type play_audio
# it will play audio form RakugoAudioPlayer with given node_id
# it will start playing from given from_pos
func play_audio(node_id: String, from_pos := 0.0) -> void:
	var parameters = {
		"node_id":node_id,
		"from_pos":from_pos
	}

	#_set_statement($Statements/PlayAudio, parameters)


# statement of type stop_audio
# it will stop audio form RakugoAudioPlayer with given node_id
func stop_audio(node_id: String) -> void:
	var parameters = {
		"node_id":node_id
	}

	#_set_statement($Statements/StopAudio, parameters)


# statement of type stop_audio
# it will stop audio form RakugoAudioPlayer with given node_id
func call_node(node_id: String, func_name: String, args := []) -> void:
	var parameters = {
		"node_id":node_id,
		"func_name":func_name,
		"args":args
	}

	#_set_statement($Statements/CallNode, parameters)


func debug_dict(
		parameters: Dictionary,
		parameters_names := [],
		some_custom_text := ""
		) -> String:

	var dbg = ""

	for k in parameters_names:
		if k in parameters:
			if not k in [null, ""]:
				dbg += k + ":" + str(parameters[k]) + ", "

	if parameters_names.size() > 0:
		dbg.erase(dbg.length() - 2, 2)

	return some_custom_text + dbg


# for printing debugs is only print if debug_on == true
# put some string array or string as argument
func debug(some_text = []) -> void:
	if not debug_on:
		return

	if not started:
		return	

	if typeof(some_text) == TYPE_ARRAY:
		var new_text = ""

		for i in some_text:
			new_text += str(i) + " "

		some_text = new_text

	print(some_text)

func get_current_store():
	return StoreManager.get_current_store()
	
func set_current_store(value):
	return 
	
