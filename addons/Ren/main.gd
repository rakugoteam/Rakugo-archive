extends Node

export (String) var game_title = "Your New Game"
export (String) var game_version = "0.0.1"
export (String) var game_credits = "Your Company"
export (String, "ren", "bbcode") var markup = "ren"
export (Color) var links_color = Color("#225ebf")
export (bool) var debug_on = true
export (String) var save_folder = "saves"
export (String) var save_password = "Ren"
export (String, DIR) var scenes_dir = "res://scenes/examples/"

const ren_version = "1.0.0"
const credits_path = "res://addons/Ren/credits.txt"

## init vars for settings
var _skip_all_text = false
var _skip_after_choices = false
var _auto_speed = 1
var _text_speed = 30
var _notify_time = 5

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
var current_id = 0 setget _set_current_id, _get_current_id
var local_id = 0
var current_dialog_name = ""
var _scene = null
var history = [] # [{"state":story_state, "statement":{"type":type, "parameters": parameters}}]
var global_history = [] # [{"state":story_state, "statement":{"type":type, "parameters": parameters}}]
var prev_story_state = ""
var variables = {}

# don't save this
var current_statement = null
var using_passer = false
var skip_auto = false
var current_node = null
var active = false
var skip_types = [
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

const weekdays={
	0:'Sunday',
	1:'Monday',
	2:'Tuesday',
	3:'Wednesday',
	4:'Thrusday',
	5:'Friday',
	6:'Saturday'
}

const months={
	1:'January',
	2:'February',
	3:'March',
	4:'April',
	5:'May',
	6:'June',
	7:'July',
	8:'August',
	9:'September',
	10:'October',
	11:'November',
	12:'December'
}

var file = File.new()
var loading_in_progress = false
var started = false
var quests = [] # list of all quests ids

# timers use by ren
onready var auto_timer = $AutoTimer
onready var skip_timer = $SkipTimer
onready var step_timer = $StepTimer
onready var dialog_timer = $DialogTimer
onready var notify_timer = $NotifyTimer

var story_state setget _set_story_state, _get_story_state

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

func _ready():
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
	define("story_state", "")

	## vars for ren settings
	define("skip_all_text", _skip_all_text)
	define("skip_after_choices", _skip_after_choices)
	define("auto_speed", _auto_speed)
	define("text_speed", _text_speed)
	define("notify_time", _notify_time)

	## test vars
	define("test_bool", false)
	define("test_float", 10.0)

	step_timer.connect("timeout", self, "_on_time_active_timeout")

func get_datetime_str():
	var d = OS.get_datetime()
	return weekdays[d['weekday']] + ' ' + months[d['month']] + ' ' + str(d['day']) + ', ' + str(d['hour']) + ':' + str(d['minute'])

func _on_time_active_timeout():
	active = true

func exec_statement(type, parameters = {}):
	emit_signal("exec_statement", type, parameters)

func exit_statement(parameters = {}):
	if loading_in_progress:
			return
	emit_signal("exit_statement", current_statement.type, parameters)

func story_step():
	if loading_in_progress:
		return
	emit_signal("story_step", current_dialog_name)

func notified():
	emit_signal("notified")

func on_show(node_id, state, show_args):
	emit_signal("show", node_id, state, show_args)

func on_hide(node):
	emit_signal("hide", node)

func on_play_anim(node_id, anim_name):
	emit_signal("play_anim", node_id, anim_name)

func on_stop_anim(node_id, reset):
	emit_signal("stop_anim", node_id, reset)

func on_play_audio(node_id, from_pos):
	emit_signal("play_audio", node_id, from_pos)

func on_stop_audio(node_id):
	emit_signal("stop_audio", node_id)

## parse text like in renpy to bbcode if mode == "ren"
## or parse bbcode with {vars} if mode == "bbcode"
## default mode = Ren.markup 
func text_passer(text, mode = markup):
	return $Text.text_passer(text, variables, mode, links_color.to_html())

## add/overwrite global variable that Ren will see
## and returns it as RenVar for easy use
func define(var_name, value = null):
	if not variables.has(var_name):
		return $Def.define(variables, var_name, value)
	else:
		return set_var(var_name, value)

## add/overwrite global variable, from string, that Ren will see
func define_from_str(var_name, var_str, var_type):
	if not variables.has(var_name):
		return $Def.define_from_str(variables, var_name, var_str, var_type)
	else:
		var value = $Def.str2value(var_str, var_type)
		var_type = $Def.str2ren_type(var_type)
		return set_var(var_name, value, var_type)

## overwrite exitsing global variable and returns it as RenVar
func set_var(var_name, value, var_type = null):
	if not variables.has(var_name):
		prints(var_name, "variable don't exist in Ren")
		return null

	if var_type == null:
		var_type = get_type(var_name)
	
	variables[var_name]._type = var_type
	variables[var_name].value = value
	return variables[var_name]

## returns exiting Ren variable as RenVar for easy use
func get_var(var_name, type = Type.VAR):
	if type != Type.VAR:
		if get_type(var_name) != type:
			return null
	return variables[var_name]

## to use with `define_from_str` func as var_type arg
func get_def_type(variable):
	return $Def.get_type(variable)

## returns value of variable defined using define
func get_value(var_name):
	return variables[var_name].value

## returns type of variable defined using define
func get_type(var_name):
	return variables[var_name].type

## just faster way to connect singal to ren's variable
func connect_var(var_name, signal_name, node, func_name, binds = [], flags = 0):
	get_var(var_name).connect(signal_name, node, func_name, binds, flags)
	
## crate new charater as global variable that Ren will see
## possible parameters: name, color, what_prefix, what_suffix, kind, avatar
func character(character_id, parameters):
	return $Def.define(variables, character_id, parameters, Type.CHARACTER)

func get_character(character_id):
	return get_var(character_id, Type.CHARACTER)

## crate new link to node as global variable that Ren will see
func node_link(node, node_id = null):
	if node_id == null:
		node_id = node.name
	
	var path
	if typeof(node) == TYPE_NODE_PATH:
		path = node
		
	elif node is Node:
		path = node.get_path()
	
	$Def.define(variables, node_id, path, Type.NODE)
	return get_node(path)

func get_node_by_id(node_id):
	var p = get_var(node_id).v
	return get_node(p)

## add/overwrite global subquest that Ren will see
## and returns it as RenSubQuest for easy use
## possible parameters: "who", "title", "description", "optional", "state", "subquests"
func subquest(var_name, parameters = {}):
	return $Def.define(variables, var_name, parameters, Type.SUBQUEST)

## returns exiting Ren subquest as RenSubQuest for easy use
func get_subquest(subquest_id):
	return get_var(subquest_id, Type.SUBQUEST)

## add/overwrite global quest that Ren will see
## and returns it as RenQuest for easy use
## possible parameters: "who", "title", "description", "optional", "state", "subquests"
func quest(var_name, parameters = {}):
	var q = $Def.define(variables, var_name, parameters, Type.QUEST)
	quests.append(var_name)
	return q

## returns exiting Ren quest as RenQuest for easy use
func get_quest(quest_id):
	return get_var(quest_id, Type.QUEST)

func _set_statement(node, parameters):
	if not parameters.has("speed"):
		parameters["speed"] = get_value("text_speed")
	node.set_parameters(parameters)
	node.exec()
	active = false
	step_timer.start()

## statement of type say
## there can be only one say, ask or menu in story_state at it end
## its make given character(who) talk (what)
## with keywords : who, what, kind, speed
## speed is time to show next letter
func say(parameters):
	_set_statement($Say, parameters)

## statement of type ask
## there can be only one say, ask or menu in story_state at it end
## its allow player to provide keybord ask that will be assain to given variable
## it also will return RenVar variable
## with keywords : who, what, kind, speed variable, value
## speed is time to show next letter
func ask(parameters):
	_set_statement($Ask, parameters)

## statement of type menu
## there can be only one say, ask or menu in story_state at it end
## its allow player to make choice
## with keywords : who, what, kind, speed choices, mkind
## speed is time to show next letter
func menu(parameters):
	_set_statement($Menu, parameters)

## it show custom ren node or charater
## 'state' arg is using to set for example current emtion or/and cloths
## 'state' example '['happy', 'green uniform']'
## with keywords : x, y, z, at, pos
## x, y and pos will use it as procent of screen if between 0 and 1
## "at" is lists that can have: "top", "center", "bottom", "right", "left"
func show(node_id, state = [], parameters = {"at":["center", "bottom"]}):
	parameters["node_id"] = node_id
	parameters["state"] = state
	_set_statement($Show, parameters)

## statement of type hide
func hide(node_id):
	var parameters = {"node_id":node_id}
	_set_statement($Hide, parameters)

## statement of type notify
func notifiy(info, length = Ren.get_value("notify_time")):
	var parameters = {"info": info,"length":length}
	_set_statement($Notify, parameters)
	notify_timer.wait_time = parameters.length
	notify_timer.start()

## statement of type play_anim
## it will play animation with anim_name form RenAnimPlayer with given node_id
func play_anim(node_id, anim_name):
	var parameters = {
		"node_id":node_id,
		"anim_name":anim_name
	}
	_set_statement($PlayAnim, parameters)

## statement of type stop_anim
## it will stop animation form RenAnimPlayer with given node_id
## and by default is reset to 0 pos on exit from statment
func stop_anim(node_id, reset = true):
	var parameters = {
		"node_id":node_id,
		"reset":reset
	}
	_set_statement($StopAnim, parameters)

## statement of type play_audio
## it will play audio form RenAudioPlayer with given node_id
## it will start playing from given from_pos
func play_audio(node_id, from_pos = 0.0):
	var parameters = {
		"node_id":node_id,
		"from_pos":from_pos
	}
	_set_statement($PlayAudio, parameters)

## statement of type stop_audio
## it will stop audio form RenAudioPlayer with given node_id
func stop_audio(node_id):
	var parameters = {
		"node_id":node_id
	}
	_set_statement($StopAudio, parameters)

## statement of type stop_audio
## it will stop audio form RenAudioPlayer with given node_id
func call_node(node_id, func_name, args = []):
	var parameters = {
		"node_id":node_id,
		"func_name":func_name,
		"args":args
	}
	_set_statement($CallNode, parameters)

func _set_story_state(state):
	prev_story_state = _get_story_state()
	define("story_state", state)

func _get_story_state():
	return get_value("story_state")

## it starts Ren
func start():
	load_global_history()
	using_passer = false
	current_id = 0
	local_id = 0
	story_step()
	started = true
	emit_signal("started")


func savefile(save_name = "quick"):
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
	data["state"] = prev_story_state # it must be this way

	var result = $Persistence.save_data(save_name)
	debug(["save data to:", save_name])
	return result
	
func loadfile(save_name = "quick"):
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

func debug_dict(parameters, parameters_names = [], some_custom_text = ""):
	var dbg = ""
	
	for k in parameters_names:
		if k in parameters:
			if not k in [null, ""]:
				dbg += k + " : " + str(parameters[k]) + ", "
	
	if parameters_names.size() > 0:
		dbg.erase(dbg.length() - 2, 2)

	return some_custom_text + dbg

## for printting debugs is only print if debug_on == true
## you put some string array or string as argument
func debug(some_text = []):
	if not debug_on:
		return
	if typeof(some_text) == TYPE_ARRAY:
		var new_text = ""
		for i in some_text:
			new_text += str(i) + " "
		some_text = new_text
	print(some_text)


func _set_current_id(value):
	current_id = value
	local_id = value

func _get_current_id():
	return current_id


## use this to change/assain current scene and dialog
## root of path_to_scene is scenes_dir
## provide path_to_scene with out ".tscn"
## "lid" is use to setup "local_id"
func jump(
	path_to_scene,
	dialog_name,
	state = "start",
	change = true,
	from_save = false,
	lid = 0):

	if not from_save and loading_in_progress:
		return

	local_id = lid
	current_dialog_name = dialog_name
	
	_set_story_state(state) # it must be this way
	
	if from_save:
		_scene = path_to_scene
	else:
		_scene = scenes_dir + path_to_scene + ".tscn"
	
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

func current_statement_in_global_history():
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

func can_auto():
	return current_statement.type in skip_types

func can_skip():
	var seen = current_statement_in_global_history()
	return can_auto() and seen

func can_qload():
	var path = str("user://", save_folder, "/quick")
	var save_exist = file.file_exists(path + ".save")
	var text_exist = file.file_exists(path + ".txt")
	return save_exist or text_exist

func save_global_history():
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

func load_global_history():
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

