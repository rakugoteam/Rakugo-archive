extends Node

export var game_title : = "Your New Game"
export var game_version : = "0.0.1"
export var game_credits : = "Your Company"
export (String, "ren", "bbcode") var markup : = "ren"
export var links_color : = Color("#225ebf")
export var debug_on : = true
export var save_folder : = "saves"
export var save_password : = "Ren"
export (String, DIR) var scenes_dir : = "res://examples/"

const ren_version : = "2.0.0"
const credits_path : = "res://addons/Ren/credits.txt"
# we need it because we hide base RenMenu form custom nodes
const RenMenu : = preload("res://addons/Ren/nodes/ren_menu.gd")

## init vars for settings
var _skip_all_text : = false
var _skip_after_choices : = false
var _auto_time : = 1
var _text_time : = 0.3
var _notify_time : = 3
var _typing_text : = true

enum Type {
	VAR,		# 0
	TEXT,		# 1
	DICT,		# 2
	LIST,		# 3
	NODE,		# 4
	QUEST,		# 5
	SUBQUEST,	# 6
	CHARACTER	# 7
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
	CALL_NODE	# 11
}

# this must be saved
var current_id : = 0 setget _set_current_id, _get_current_id
var local_id : = 0
var current_dialog_name : = ""
var _scene : = ""
var history : = [] # [{"state":story_state, "statement":{"type":type, "parameters": parameters}}]
var global_history : = [] # [{"state":story_state, "statement":{"type":type, "parameters": parameters}}]
var variables : = {}

# don't save this
onready var menu_node : RenMenu = $Menu
var current_node : Node = null
var current_statement : Statement = null
var using_passer : = false
var skip_auto : = false
var active : = false
var can_alphanumeric:= true
var skip_types : = [
	StatementType.SAY,
	StatementType.SHOW,
	StatementType.HIDE,
	StatementType.NOTIFY,
	StatementType.PLAY_ANIM,
	StatementType.STOP_ANIM,
	StatementType.PLAY_AUDIO,
	StatementType.STOP_AUDIO,
	StatementType.CALL_NODE
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

var file : = File.new()
var loading_in_progress : = false
var started : = false
var quests : = [] # list of all quests ids

# timers use by ren
onready var auto_timer : = $AutoTimer
onready var skip_timer : = $SkipTimer
onready var step_timer : = $StepTimer
onready var dialog_timer : = $DialogTimer
onready var notify_timer : = $NotifyTimer

var story_state : int setget _set_story_state, _get_story_state

signal started
signal exec_statement(type, parameters)
signal exit_statement(previous_type, parameters)
signal notified()
signal show(node_id, state, show_args)
signal hide(node_id)
signal story_step(dialog_name)
signal play_anim(node_id, anim_name)
signal stop_anim(node_id, reset)
signal play_audio(node_id, from_pos)
signal stop_audio(node_id)

func _ready() -> void:
	## set by game devloper
	define("title", game_title)
	define("version", game_version)
	OS.set_window_title(game_title + " " + game_version)
	define("credits", game_credits)

	## set by ren
	define("ren_version", ren_version)
	file.open(credits_path, file.READ)
	define("ren_credits", file.get_as_text())
	file.close()
	var gdv = Engine.get_version_info()
	var gdv_string = str(gdv.major) + "." + str(gdv.minor) + "." + str(gdv.patch)
	define("godot_version", gdv_string)
	define("story_state", 0)

	## vars for ren settings
	define("skip_all_text", _skip_all_text)
	define("skip_after_choices", _skip_after_choices)
	define("auto_time", _auto_time)
	define("text_time", _text_time)
	define("notify_time", _notify_time)
	define("typing_text", _typing_text)

	## test vars
	define("test_bool", false)
	define("test_float", 10.0)

	step_timer.connect("timeout", self, "_on_time_active_timeout")

func get_datetime_str() -> String:
	var d = OS.get_datetime()
	return weekdays[d['weekday']] + ' ' + months[d['month']] + ' ' + str(d['day']) + ', ' + str(d['hour']) + ':' + str(d['minute'])

func _on_time_active_timeout() -> void:
	active = true

func exec_statement(type : int, parameters : = {}) -> void:
	emit_signal("exec_statement", type, parameters)

func exit_statement(parameters : = {}) -> void:
	if loading_in_progress:
			return
	emit_signal("exit_statement", current_statement.type, parameters)

func story_step() -> void:
	if loading_in_progress:
		return
	emit_signal("story_step", current_dialog_name)

func notified() -> void:
	emit_signal("notified")

func on_show(node_id : String, state : Array, show_args : Dictionary) -> void:
	emit_signal("show", node_id, state, show_args)

func on_hide(node_id : String) -> void:
	emit_signal("hide", node_id)

func on_play_anim(node_id : String, anim_name : String) -> void:
	emit_signal("play_anim", node_id, anim_name)

func on_stop_anim(node_id : String, reset : bool) -> void:
	emit_signal("stop_anim", node_id, reset)

func on_play_audio(node_id : String, from_pos : float) -> void:
	emit_signal("play_audio", node_id, from_pos)

func on_stop_audio(node_id : String) -> void:
	emit_signal("stop_audio", node_id)

## parse text like in renpy to bbcode if mode == "ren"
## or parse bbcode with {vars} if mode == "bbcode"
## default mode = Ren.markup 
func text_passer(text : String, mode : = markup):
	return $Text.text_passer(text, variables, mode, links_color.to_html())

## add/overwrite global variable that Ren will see
## and returns it as RenVar for easy use
func define(var_name : String, value = null) -> Object:
	if not variables.has(var_name):
		return $Def.define(variables, var_name, value)
	else:
		return set_var(var_name, value)

## add/overwrite global variable, from string, that Ren will see
func define_from_str(var_name : String, var_str : String, var_type : String) -> Object:
	if not variables.has(var_name):
		return $Def.define_from_str(variables, var_name, var_str, var_type)
	else:
		var value = $Def.str2value(var_str, var_type)
		var var_type_int = $Def.str2ren_type(var_type)
		return set_var(var_name, value, var_type_int)

## overwrite exitsing global variable and returns it as RenVar
func set_var(var_name : String, value, var_type : = -1) -> Object:
	if not variables.has(var_name):
		prints(var_name, "variable don't exist in Ren")
		return null

	if var_type == -1:
		var_type = get_type(var_name)
	
	variables[var_name]._type = var_type
	variables[var_name].value = value
	return variables[var_name]

## returns exiting Ren variable as one of RenTypes for easy use
## It must be with out returned type, because we can't set it as list of types
func get_var(var_name : String, type : = Type.VAR):
	if type != Type.VAR:
		if get_type(var_name) != type:
			return null
	return variables[var_name]

## to use with `define_from_str` func as var_type arg
## it can't use optinal typing
func get_def_type(variable):
	return $Def.get_type(variable)

## returns value of variable defined using define
## It must be with out returned type, because we can't set it as list of types
func get_value(var_name : String):
	return variables[var_name].value

## returns type of variable defined using define
func get_type(var_name : String) -> int:
	return variables[var_name].type

## just faster way to connect singal to ren's variable
func connect_var(var_name : String, signal_name : String, node : Object, func_name : String, binds : = [], flags : = 0) -> void:
	get_var(var_name).connect(signal_name, node, func_name, binds, flags)
	
## crate new charater as global variable that Ren will see
## possible parameters: name, color, what_prefix, what_suffix, kind, avatar
func character(character_id : String, parameters : Dictionary) -> CharacterObject:
	return $Def.define(variables, character_id, parameters, Type.CHARACTER)

func get_character(character_id : String) -> CharacterObject:
	return get_var(character_id, Type.CHARACTER)

## crate new link to node as global variable that Ren will see
## first arg can be node it self or path to it
func node_link(node, node_id : String = "") -> Node:
	if node_id == "":
		node_id = node.name

	var path
	if typeof(node) == TYPE_NODE_PATH:
		path = node

	elif node is Node:
		path = node.get_path()

	$Def.define(variables, node_id, path, Type.NODE)
	return get_node(path)

func get_node_by_id(node_id : String) -> Node:
	var p = get_var(node_id).v
	return get_node(p)

## add/overwrite global subquest that Ren will see
## and returns it as RenSubQuest for easy use
## possible parameters: "who", "title", "description", "optional", "state", "subquests"
func subquest(var_name : String, parameters : = {}) -> Subquest:
	return $Def.define(variables, var_name, parameters, Type.SUBQUEST)

## returns exiting Ren subquest as RenSubQuest for easy use
func get_subquest(subquest_id : String) -> Subquest:
	return get_var(subquest_id, Type.SUBQUEST)

## add/overwrite global quest that Ren will see
## and returns it as RenQuest for easy use
## possible parameters: "who", "title", "description", "optional", "state", "subquests"
func quest(var_name : String, parameters : = {}) -> Quest:
	var q = $Def.define(variables, var_name, parameters, Type.QUEST)
	quests.append(var_name)
	return q

## returns exiting Ren quest as RenQuest for easy use
func get_quest(quest_id : String) -> Quest:
	return get_var(quest_id, Type.QUEST)

## it should be "node : Statement", but it don't work for now
func _set_statement(node : Node, parameters : Dictionary) -> void:		
	node.set_parameters(parameters)
	node.exec()
	active = false
	step_timer.start()

## statement of type say
## there can be only one say, ask or menu in story_state at it end
## its make given character(who) talk (what)
## with keywords : who, what, typing, kind
## speed is time to show next letter
func say(parameters : Dictionary) -> void:
	_set_statement($Say, parameters)

## statement of type ask
## there can be only one say, ask or menu in story_state at it end
## its allow player to provide keybord ask that will be assain to given variable
## it also will return RenVar variable
## with keywords : who, what, typing, kind, variable, value
## speed is time to show next letter
func ask(parameters : Dictionary) -> void:
	_set_statement($Ask, parameters)

## statement of type menu
## there can be only one say, ask or menu in story_state at it end
## its allow player to make choice
## with keywords : who, what, typing, kind, choices, mkind
## speed is time to show next letter
func menu(parameters : Dictionary) -> void:
	_set_statement($Menu, parameters)

## it show custom ren node or charater
## 'state' arg is using to set for example current emtion or/and cloths
## 'state' example '['happy', 'green uniform']'
## with keywords : x, y, z, at, pos
## x, y and pos will use it as procent of screen if between 0 and 1
## "at" is lists that can have: "top", "center", "bottom", "right", "left"
func show(node_id : String, state : PoolStringArray = [], parameters : = {"at":["center", "bottom"]}):
	parameters["node_id"] = node_id
	parameters["state"] = state
	_set_statement($Show, parameters)

## statement of type hide
func hide(node_id : String) -> void:
	var parameters = {"node_id":node_id}
	_set_statement($Hide, parameters)

## statement of type notify
func notifiy(info : String, length : int = Ren.get_value("notify_time")) -> void:
	var parameters = {"info": info,"length":length}
	_set_statement($Notify, parameters)
	notify_timer.wait_time = parameters.length
	notify_timer.start()

## statement of type play_anim
## it will play animation with anim_name form RenAnimPlayer with given node_id
func play_anim(node_id : String, anim_name : String) -> void:
	var parameters = {
		"node_id":node_id,
		"anim_name":anim_name
	}
	_set_statement($PlayAnim, parameters)

## statement of type stop_anim
## it will stop animation form RenAnimPlayer with given node_id
## and by default is reset to 0 pos on exit from statment
func stop_anim(node_id : String, reset : = true) -> void:
	var parameters = {
		"node_id":node_id,
		"reset":reset
	}
	_set_statement($StopAnim, parameters)

## statement of type play_audio
## it will play audio form RenAudioPlayer with given node_id
## it will start playing from given from_pos
func play_audio(node_id : String, from_pos : = 0.0) -> void:
	var parameters = {
		"node_id":node_id,
		"from_pos":from_pos
	}
	_set_statement($PlayAudio, parameters)

## statement of type stop_audio
## it will stop audio form RenAudioPlayer with given node_id
func stop_audio(node_id : String) -> void:
	var parameters = {
		"node_id":node_id
	}
	_set_statement($StopAudio, parameters)

## statement of type stop_audio
## it will stop audio form RenAudioPlayer with given node_id
func call_node(node_id : String, func_name : String, args : = []) -> void:
	var parameters = {
		"node_id":node_id,
		"func_name":func_name,
		"args":args
	}
	_set_statement($CallNode, parameters)

func _set_story_state(state : int) -> void:
	define("story_state", state)

func _get_story_state() -> int:
	return get_value("story_state")

## it starts Ren
func start() -> void:
	load_global_history()
	using_passer = false
	current_id = 0
	local_id = 0
	story_step()
	started = true
	emit_signal("started")


func savefile(save_name : = "quick") -> bool:
	$Persistence.folder_name = save_folder
	$Persistence.password = save_password

	var data = $Persistence.get_data(save_name)
	debug(["get data from:", save_name])
	if data == null:
		return false

	data["history"] = history.duplicate()

	var vars_to_save = {}
	for i in range(variables.size()):
		var k = variables.keys()[i]
		var v = variables.values()[i]

		debug([k, v])

		if v.type == Type.CHARACTER:
			vars_to_save[k] = {"type":v.type, "value":v.character2dict()}
		elif v.type == Type.SUBQUEST:
			vars_to_save[k] = {"type":v.type, "value":v.subquest2dict()}
		elif v.type == Type.QUEST:
			vars_to_save[k] = {"type":v.type, "value":v.quest2dict()}
		else:
			vars_to_save[k] = {"type":v.type, "value":v.value}

	data["variables"] = vars_to_save

	data["id"] = current_id
	data["local_id"] = local_id
	data["scene"] = _scene
	data["dialog_name"] = current_dialog_name
	data["state"] = story_state - 1 # it must be this way

	var result = $Persistence.save_data(save_name)
	debug(["save data to:", save_name])
	return result
	
func loadfile(save_name : = "quick") -> bool:
	loading_in_progress = true
	$Persistence.folder_name = save_folder
	$Persistence.password = save_password
	
	var data = $Persistence.get_data(save_name)
	debug(["load data from:", save_name])
	if data == null:
		return false

	quests.clear()
	history = data["history"].duplicate()

	var vars_to_load = data["variables"].duplicate()

	for i in range(vars_to_load.size()):
		var k = vars_to_load.keys()[i]
		var v = vars_to_load.values()[i]

		debug([k, v])

		if v.type == Type.CHARACTER:
			character(k, v.value)
		elif v.type == Type.SUBQUEST:
			subquest(k, v.value)
		elif v.type == Type.QUEST:
			quest(k, v.value)
			if k in quests:
				continue
			quests.append(k)
		else:
			define(k, v.value)
			
	for q_id in quests:
		var q = get_quest(q_id)
		q.update_subquests()
	
	started = true

	jump(
		data["scene"],
		data["dialog_name"],
		data["state"],
		true, true,
		data["local_id"]
		)

	current_id = data["id"]
	return true

func debug_dict(parameters : Dictionary, parameters_names : = [], some_custom_text : = "") -> String:
	var dbg = ""
	
	for k in parameters_names:
		if k in parameters:
			if not k in [null, ""]:
				dbg += k + " : " + str(parameters[k]) + ", "
	
	if parameters_names.size() > 0:
		dbg.erase(dbg.length() - 2, 2)

	return some_custom_text + dbg

## for printting debugs is only print if debug_on == true
## put some string array or string as argument
func debug(some_text = []) -> void:
	if not debug_on:
		return
		
	if typeof(some_text) == TYPE_ARRAY:
		var new_text = ""
		
		for i in some_text:
			new_text += str(i) + " "
			
		some_text = new_text
		
	print(some_text)


func _set_current_id(value : int) -> void:
	current_id = value
	local_id = value

func _get_current_id() -> int:
	return current_id

## use this to change/assain current scene and dialog
## root of path_to_scene is scenes_dir
## provide path_to_scene with out ".tscn"
## "lid" is use to setup "local_id"
func jump(
	path_to_scene : String,
	dialog_name : String,
	state : = 0,
	change : = true,
	from_save : = false,
	lid : = 0) -> void:

	if not from_save and loading_in_progress:
		return

	local_id = lid
	current_dialog_name = dialog_name
	
	_set_story_state(state) # it must be this way
	
	if from_save:
		_scene = path_to_scene
	else:
		_scene = scenes_dir + "/" + path_to_scene + ".tscn"
	
	debug(["jump to scene:", _scene, "with dialog:", dialog_name, "from:", state])

	if change:
		if current_node != null:
			current_node.queue_free()
		
		var lscene = load(_scene)
		current_node = lscene.instance()
		get_tree().get_root().add_child(current_node)

	if loading_in_progress:
		loading_in_progress = false
	
	if started:
		story_step()

## it don't work :(
func current_statement_in_global_history() -> bool:
	var r = true
	var i = 0
	var hi_item = current_statement.get_as_history_item()
	# prints(hi_item)
	
	if not current_statement.parameters.add_to_history:
		i = 1
		r = true
		# prints("r =", str(r), "i =", str(i))
		return r
	
	if not hi_item.has("state"):
		i = 2
		r = true
		# prints("r =", str(r), "i =", str(i))
		return r
	
	i = 3
	r = hi_item in global_history
	# prints("r =", str(r), "i =", str(i))
	return r

func can_auto() -> bool:
	return current_statement.type in skip_types

## it don't work :(
func can_skip() -> bool:
	var seen = current_statement_in_global_history()
	return can_auto() and seen

func can_qload() -> bool:
	return is_save_exits("quick")

func is_save_exits(save_name : String) -> bool:
	var path = str("user://", save_folder, "/", save_name)
	var save_exist = file.file_exists(path + ".save")
	var text_exist = file.file_exists(path + ".txt")
	return save_exist or text_exist

func save_global_history() -> bool:
	var save_name = "global_history"
	$Persistence.folder_name = save_folder
	$Persistence.password = save_password

	var data = $Persistence.get_data(save_name)
	debug(["get global_history from:", save_name])
	if data == null:
		return false

	data["global_history"] = global_history.duplicate()
	
	var result = $Persistence.save_data(save_name)
	debug(["save global_history to:", save_name])
	return result

func load_global_history() -> bool:
	var save_name = "global_history"
	$Persistence.folder_name = save_folder
	$Persistence.password = save_password
	global_history = []
	var data = $Persistence.get_data(save_name)
	debug(["load global_history from:", save_name])
	if data == null:
		return false
	
	if "global_history" in data:
		global_history = data["global_history"].duplicate()
		
	return true

func _exit_tree():
	history.clear()
	global_history.clear()
	variables.clear()