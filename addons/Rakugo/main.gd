extends Node

const rakugo_version := "2.1.04"
const credits_path := "res://addons/Rakugo/credits.txt"
const save_folder := "saves"

# project settings integration
onready var game_title = ProjectSettings.get_setting("application/config/name")
onready var game_version = ProjectSettings.get_setting("application/rakugo/version")
onready var game_credits = ProjectSettings.get_setting("application/rakugo/game_credits")
onready var markup = ProjectSettings.get_setting("application/rakugo/markup")
onready var debug_on = ProjectSettings.get_setting("application/rakugo/debug")
onready var test_save = ProjectSettings.get_setting("application/rakugo/test_saves")
onready var scene_links = ProjectSettings.get_setting("application/rakugo/scene_links")

onready var theme = load(ProjectSettings.get_setting("application/rakugo/theme"))
onready var default_kind = ProjectSettings.get_setting("application/rakugo/default_kind")
onready var default_mkind = ProjectSettings.get_setting("application/rakugo/default_mkind")
onready var default_mcolumns = ProjectSettings.get_setting("application/rakugo/default_mcolumns")
onready var default_manchor = ProjectSettings.get_setting("application/rakugo/default_manchor")

# init vars for settings
var _skip_all_text := false
var _skip_after_choices := false
var _auto_time := 1
var _text_time := 0.3
var _notify_time := 3
var _typing_text := true

enum Type {
	VAR,		# 0
	TEXT,		# 1
	DICT,		# 2
	LIST,		# 3
	NODE,		# 4
	QUEST,		# 5
	SUBQUEST,	# 6
	CHARACTER,	# 7
	RANGED,		# 8
	BOOL,		# 9
	VECT2, # 10
	VECT3, # 11
	AVATAR, # 12
	COLOR, # 13
}

enum StatementType {
	BASE,		# 0
	SAY,		# 1
	ASK,		# 2
	MENU,		# 3
	SHOW,		# 4
	HIDE,		# 5
	NOTIFY,		# 6
	PLAY_ANIM,	# 7
	STOP_ANIM,	# 8
	PLAY_AUDIO,	# 9
	STOP_AUDIO,	# 10
	CALL_NODE,	# 11
}

# this must be saved
var history_id := 0 setget _set_history_id, _get_history_id
var current_dialog_name := ""
var current_node_name := ""
var current_scene := ""

# {["scene_id", "node_name", "dialog_name", story_step]:{"type":type, "parameters": parameters}}
var history := {}
var global_history := {}
var variables := {}

# don't save this
onready var menu_node: = $Menu
var viewport : Viewport
var loading_screen : RakugoControl
var current_scene_path := ""
var current_root_node: Node = null
var current_statement: Statement = null
var skip_auto := false
var active := false
var can_alphanumeric := true
var emoji_size := 16
var skipping := false
var current_dialogs := {}

const skip_types := [
	StatementType.SAY,
	StatementType.SHOW,
	StatementType.HIDE,
	StatementType.NOTIFY,
	StatementType.PLAY_ANIM,
	StatementType.STOP_ANIM,
	StatementType.PLAY_AUDIO,
	StatementType.STOP_AUDIO,
	StatementType.CALL_NODE,
]

const weekdays = {
	0: 'Sunday',
	1: 'Monday',
	2: 'Tuesday',
	3: 'Wednesday',
	4: 'Thrusday',
	5: 'Friday',
	6: 'Saturday',
}

const months = {
	1: 'January',
	2: 'February',
	3: 'March',
	4: 'April',
	5: 'May',
	6: 'June',
	7: 'July',
	8: 'August',
	9: 'September',
	10: 'October',
	11: 'November',
	12: 'December',
}

var file := File.new()
var loading_in_progress := false
var started := false
var quests := [] # list of all quests ids

# timers use by rakugo
onready var auto_timer := $AutoTimer
onready var skip_timer := $SkipTimer
onready var step_timer := $StepTimer
onready var dialog_timer := $DialogTimer
onready var notify_timer := $NotifyTimer

# saved automatically - it is RagukoVar
var story_state:int setget _set_story_state, _get_story_state

signal started
signal exec_statement(type, parameters)
signal exit_statement(previous_type, parameters)
signal notified()
signal show(node_id, state, show_args)
signal hide(node_id)
signal story_step(node_name, dialog_name)
signal play_anim(node_id, anim_name)
signal stop_anim(node_id, reset)
signal play_audio(node_id, from_pos)
signal stop_audio(node_id)
signal begin
signal hide_ui(value)
signal checkpoint
signal game_ended

func load_init_data() -> void:
	$LoadFile.load_data("res://addons/Rakugo/init.tres")


func _ready() -> void:

	load_init_data()

	# set by game developer
	define("title", game_title, true)
	define("version", game_version, true)
	OS.set_window_title(game_title + " " + game_version)
	define("credits", game_credits, true)

	# it must be before define rakugo_version and godot_version to parse corretly :o
	file.open(credits_path, file.READ)
	define("rakugo_credits", file.get_as_text(), false)
	file.close()

	# set by rakugo
	define("rakugo_version", rakugo_version, true)

	var gdv = Engine.get_version_info()
	var gdv_string = str(gdv.major) + "." + str(gdv.minor) + "." + str(gdv.patch)
	define("godot_version", gdv_string, true)
	define("story_state", 0)
	define("v2_inf", Vector2.INF, false)
	define("v3_inf", Vector3.INF, false)

	step_timer.connect("timeout", self, "_on_time_active_timeout")


func get_datetime_str() -> String:
	var d = OS.get_datetime()
	var s: String = weekdays[d['weekday']] + ' '
	s += months[d['month']] + ' '
	s += str(d['day']) + ', '
	s += str(d['hour']) + ':'
	s += str(d['minute'])
	return s


func _on_time_active_timeout() -> void:
	active = true


func exec_statement(type: int, parameters := {}) -> void:
	emit_signal("exec_statement", type, parameters)


func exit_statement(parameters := {}) -> void:
	emit_signal("exit_statement", current_statement.type, parameters)


func get_dialog_nodes_names() -> Array:
	var arr = []

	for n in current_dialogs.keys():
		arr.append(n.name)

	return arr


func get_dialogs(node_name:String) -> Array:
	var id := get_dialog_nodes_names().find(node_name)

	if id > -1:
		var k = current_dialogs.keys()[id]
		return current_dialogs[k]

	return []


func story_step() -> void:
	if (
		current_node_name != "" and
		not(current_node_name in get_dialog_nodes_names())
		):
		push_error("Node %s is not added to dialogs nodes" % current_node_name)

	elif (
		current_dialog_name != "" and
		not (current_dialog_name in get_dialogs(current_node_name))
		):
		push_error("Node %s is not added %s to dialogs"
			% [current_node_name, current_dialog_name])

	emit_signal("story_step", current_node_name, current_dialog_name)


func notified() -> void:
	emit_signal("notified")


func on_show(node_id: String, state: Array, show_args: Dictionary) -> void:
	emit_signal("show", node_id, state, show_args)


func on_hide(node_id: String) -> void:
	emit_signal("hide", node_id)


func on_play_anim(node_id: String, anim_name: String) -> void:
	emit_signal("play_anim", node_id, anim_name)


func on_stop_anim(node_id: String, reset: bool) -> void:
	emit_signal("stop_anim", node_id, reset)


func on_play_audio(node_id: String, from_pos: float) -> void:
	emit_signal("play_audio", node_id, from_pos)


func on_stop_audio(node_id: String) -> void:
	emit_signal("stop_audio", node_id)


func clean_dialogs() -> void:
	for n in current_dialogs.keys():
		for f in current_dialogs[n]:
			if is_connected("story_step", n, f):
				disconnect("story_step", n, f)

		current_dialogs.erase(n)

# use to add/register dialog
# func_name is name of func that is going to be use as dialog
func add_dialog(node: Node, func_name: String) -> void:
	if not is_connected("story_step", node, func_name):
		connect("story_step", node, func_name)

		if not (node in current_dialogs.keys()):
			current_dialogs[node] = []

		current_dialogs[node].append(func_name)
		debug(["add dialog", func_name, "from", node.name])


# parse text like in renpy to bbcode if mode == "renpy"
# or parse bbcode with {vars} if mode == "bbcode"
# default mode = Rakugo.markup
func text_passer(text: String, mode := markup):
	return $Text.text_passer(text, variables, mode, theme.links_color.to_html())


# add/overwrite global variable that Rakugo will see
# and returns it as RakugoVar for easy use
func define(var_name: String, value = null, save_included := true) -> RakugoVar:
	var v = $Define.invoke(var_name, value , save_included)

	if v:
		return v

	else:
		return set_var(var_name, value)


func str2value(str_value: String, var_type: String):
	match var_type:
		"str":
			return str_value

		"bool":
			return bool(str_value)

		"int":
			return int(str_value)

		"float":
			return float(str_value)


# add/overwrite global variable, from string, that Rakugo will see
func define_from_str(var_name: String, var_str: String, var_type: String) -> RakugoVar:
	var value = str2value(var_str, var_type)
	if not variables.has(var_name):
		return define(var_name, value)

	return set_var(var_name, value)


# overwrite existing global variable and returns it as RakugoVar
func set_var(var_name: String, value) -> RakugoVar:
	if not (var_name in variables):
		push_warning("%s variable don't exist in Rakugo" %var_name)
		return null

	var var_to_change = variables[var_name]
	var_to_change.value = value
	return var_to_change


# returns exiting Rakugo variable as one of RakugoTypes for easy use
# It must be with out returned type, because we can't set it as list of types
func get_var(var_name: String) -> RakugoVar:
	return $GetVar.invoke(var_name)


# to use with `define_from_str` func as var_type arg
# it can't use optional typing
func get_def_type(variable) -> String:
	var type = "str"

	match typeof(variable):
		TYPE_BOOL:
			type = "bool"

		TYPE_INT:
			type = "int"

		TYPE_REAL:
			type = "float"

	return type


# returns value of variable defined using define
# It must be with out returned type, because we can't set it as list of types
func get_value(var_name: String):
	if variables.has(var_name):
		return variables[var_name].value

	return null


func get_node_value(var_name:String) -> Dictionary:
	var p = NodeLink.new("").var_prefix
	return get_value(p + var_name)


func get_avatar_value(var_name: String) -> Dictionary:
	var p = Avatar.new("").var_prefix
	return get_value(p + var_name)


# returns type of variable defined using define
func get_type(var_name: String) -> int:
	return variables[var_name].type


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


# crate new RangedVar as global variable that Rakugo will see
func ranged_var(var_name, start_value := 0.0, min_value := 0.0, max_value := 0.0) -> RakugoRangedVar:
	var rrv = RakugoRangedVar.new(var_name, start_value, min_value, max_value)
	variables[var_name] = rrv
	return rrv


# crate new character as global variable that Rakugo will see
# possible parameters: name, color, prefix, suffix, avatar, stats, kind
func character(character_id: String, parameters := {}) -> CharacterObject:
	var new_ch := CharacterObject.new(character_id, parameters)
	variables[character_id] = new_ch
	return new_ch


# crate new link to node as global variable that Rakugo will see
# it can have name as other existing varbiable
func node_link(node_id: String, node: NodePath) -> NodeLink:
	return $Define.node_link(node_id, node, variables)


func get_node_link(node_id: String) -> NodeLink:
	var s = NodeLink.new("").var_prefix
	return get_var(s + node_id) as NodeLink


# crate new link to node avatar as global variable that Rakugo will see
# it can have name as other existing varbiable
func avatar_link(node_id: String, node: NodePath) -> Avatar:
	return $Define.avatar_link(node_id, node, variables)


func get_avatar_link(node_id: String) -> Avatar:
	var s = Avatar.new("").var_prefix
	return get_var(s + node_id) as Avatar


# add/overwrite global subquest that Rakugo will see
# and returns it as RakugoSubQuest for easy use
# possible parameters: "who", "title", "description", "optional", "state", "subquests"
func subquest(subquest_id: String, parameters := {}) -> Subquest:
	var new_subq := Subquest.new(subquest_id, parameters)
	new_subq.save_included = true
	variables[subquest_id] = new_subq
	return new_subq


# add/overwrite global quest that Rakugo will see
# and returns it as RakugoQuest for easy use
# possible parameters: "who", "title", "description", "optional", "state", "subquests"
func quest(quest_id: String, parameters := {}) -> Quest:
	var q := Quest.new(quest_id, parameters)
	q.save_included = true
	variables[quest_id] = q
	quests.append(quest_id)
	return q


# it should be "node:Statement", but it don't work for now
func _set_statement(node: Node, parameters: Dictionary) -> void:
	node.set_parameters(parameters)
	node.exec()
	active = false
	step_timer.start()


# statement of type say
# there can be only one say, ask or menu in story_state at it end
# its make given character(who) talk (what)
# with keywords: who, what, typing, type_speed, kind, avatar, avatar_state, add
# speed is time to show next letter
func say(parameters: Dictionary) -> void:
	_set_statement($Say, parameters)


# statement of type ask
# there can be only one say, ask or menu in story_state at it end
# its allow player to provide keyboard ask that will be assign to given variable
# it also will return RakugoVar variable
# with keywords: who, what, typing, type_speed, kind, variable, value, avatar, avatar_state, add
# speed is time to show next letter
func ask(parameters: Dictionary) -> void:
	_set_statement($Ask, parameters)


# statement of type menu
# there can be only one say, ask or menu in story_state at it end
# its allow player to make choice
# with keywords:who, what, typing, type_speed, kind, choices, mkind, avatar, avatar_state, add
# speed is time to show next letter
func menu(parameters: Dictionary) -> void:
	_set_statement($Menu, parameters)


# it show custom rakugo node or character
# 'state' arg is using to set for example current emotion or/and cloths
# 'state' example '['happy', 'green uniform']'
# with keywords:x, y, z, at, pos
# x, y and pos will use it as protect of screen if between 0 and 1
# "at" is lists that can have: "top", "center", "bottom", "right", "left"
func show(node_id:String, parameters := {"state": []}):
	parameters["node_id"] = node_id
	_set_statement($Show, parameters)


# statement of type hide
func hide(node_id: String) -> void:
	var parameters = {
		"node_id":node_id
	}

	_set_statement($Hide, parameters)


# statement of type notify
func notify(info: String, length: int = get_value("notify_time")) -> void:
	var parameters = {
		"info": info,
		"length":length
	}

	_set_statement($Notify, parameters)
	notify_timer.wait_time = parameters.length
	notify_timer.start()


# statement of type play_anim
# it will play animation with anim_name form RakugoAnimPlayer with given node_id
func play_anim(node_id: String, anim_name: String) -> void:
	var parameters = {
		"node_id":node_id,
		"anim_name":anim_name
	}

	_set_statement($PlayAnim, parameters)


# statement of type stop_anim
# it will stop animation form RakugoAnimPlayer with given node_id
# and by default is reset to 0 pos on exit from statment
func stop_anim(node_id: String, reset := true) -> void:
	var parameters = {
		"node_id":node_id,
		"reset":reset
	}

	_set_statement($StopAnim, parameters)


# statement of type play_audio
# it will play audio form RakugoAudioPlayer with given node_id
# it will start playing from given from_pos
func play_audio(node_id: String, from_pos := 0.0) -> void:
	var parameters = {
		"node_id":node_id,
		"from_pos":from_pos
	}

	_set_statement($PlayAudio, parameters)


# statement of type stop_audio
# it will stop audio form RakugoAudioPlayer with given node_id
func stop_audio(node_id: String) -> void:
	var parameters = {
		"node_id":node_id
	}

	_set_statement($StopAudio, parameters)


# statement of type stop_audio
# it will stop audio form RakugoAudioPlayer with given node_id
func call_node(node_id: String, func_name: String, args := []) -> void:
	var parameters = {
		"node_id":node_id,
		"func_name":func_name,
		"args":args
	}

	_set_statement($CallNode, parameters)


func _set_story_state(state: int) -> void:
	define("story_state", state)


func _get_story_state() -> int:
	return get_value("story_state")


# it starts Rakugo
func start(after_load := false) -> void:
	load_global_history()
	history_id = 0
	started = true

	if not after_load:
		emit_signal("started")
		story_step()


func savefile(save_name := "quick") -> bool:
	debug(["save data to :", save_name])
	return $SaveFile.invoke(save_name)


func loadfile(save_name := "quick") -> bool:
	return $LoadFile.invoke(save_folder, save_name, variables)


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

	if typeof(some_text) == TYPE_ARRAY:
		var new_text = ""

		for i in some_text:
			new_text += str(i) + " "

		some_text = new_text

	print(some_text)


func _set_history_id(value: int) -> void:
	history_id = value


func _get_history_id() -> int:
	return history_id


# use this to change/assign current scene and dialog
# id_of_current_scene is id to scene defined in scene_links or full path to scene
func jump(
		scene_id: String, node_name: String,
		dialog_name: String, state := 0, force_reload := false
		) -> void:

	$Jump.invoke(
		scene_id,
		node_name, dialog_name,
		state, force_reload
	)


# use this to load scene don't start with dialog or don't have any
func load_scene(scene_id: String) -> void:
	$Jump.load_scene(scene_id)


func end_game() -> void:
	if current_root_node != null:
		current_root_node.queue_free()

	var start_scene = ProjectSettings.get_setting("application/run/main_scene")
	var lscene = load(start_scene)
	current_root_node = lscene.instance()
	get_tree().get_root().add_child(current_root_node)
	started = false
	quests.clear()
	history.clear()
	history_id = 0
	variables.clear()
	load_init_data()
	emit_signal("game_ended")


# use this to assign beginning scene and dialog
# root of path_to_current_scene is scenes_dir
# provide path_to_current_scene with out ".tscn"
func on_begin(path_to_current_scene: String, node_name: String, dialog_name: String) -> void:
	if loading_in_progress:
		return

	var resource = load(scene_links).get_as_dict()
	debug([resource, path_to_current_scene])
	var path = resource[path_to_current_scene]

	if path is PackedScene:
		current_scene_path = path.resource_path
	else:
		current_scene_path = path

	jump(path_to_current_scene, node_name , dialog_name)


func can_go_back():
	return is_save_exits("back")


func checkpoint():
	if savefile("back"):
		emit_signal("checkpoint")


func go_back():
	loadfile("back")


func is_current_statement_in_global_history() -> bool:

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


func can_auto() -> bool:
	return current_statement.type in skip_types


func can_skip() -> bool:
	var seen = is_current_statement_in_global_history()
	return can_auto() and seen


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
