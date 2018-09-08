extends Node

export (bool) var debug_on = true
export (bool) var debug_inti = true
export (String) var save_folder = "saves"
export (String) var save_password = "Ren"
export (String, DIR) var scenes_dir = "res://scenes/examples/"

const FOLDER_CONFIG_NAME = "Config"
const FILE_CONFIG_NAME = "Config"

# this must be saved
var current_id = 0 setget _set_current_id, _get_current_id
var local_id = 0
var current_dialog_name = ""
var _scene = null
var history = [] # [{"state":story_state, "statement":{"type":type, "kwargs": kwargs}}]
var global_history = [] # [{"state":story_state, "statement":{"type":type, "kwargs": kwargs}}]
var prev_story_state = ""
var variables = {
	"version":{"type":"text", "value":"0.9.6"},
	"test_bool":{"type":"var", "value":false},
	"test_float":{"type":"var", "value":10},
	"story_state":{"type":"text", "value":""}
}

# don't save this
onready var menu_node = $Menu
var current_statement = null
var using_passer = false
var skip_auto = false
var current_node = null
var skip_types = ["say", "show", "hide"]
var file = File.new()
var loading_in_progress = false
var started = false
var quests = [] # list of all quests ids

const _CHR		= preload("nodes/character.gd")
const _VAR		= preload("ren_var.gd")
const _QUEST	= preload("RPGSystem/quest.gd")
const _SUBQ		= preload("RPGSystem/subquest.gd")
onready var timer = $Timer

var story_state setget _set_story_state, _get_story_state

signal exec_statement(type, kwargs)
signal exit_statement(previous_type, kwargs)
signal notified()
signal show(node_id, state, show_args)
signal hide(node_id)
signal var_changed(var_name)
signal story_step(dialog_name)
signal play_anim(node_id, anim_name, reset)

func _ready():
	config_data()
	timer.connect("timeout", self, "exit_statement")

func exec_statement(type, kwargs = {}):
	emit_signal("exec_statement", type, kwargs)

func exit_statement(kwargs = {}):
	emit_signal("exit_statement", current_statement.type, kwargs)

func story_step():
	emit_signal("story_step", current_dialog_name)

func notified():
	emit_signal("notified")

func on_show(node_id, state, show_args):
	emit_signal("show", node_id, state, show_args)

func on_hide(node):
	emit_signal("hide", node)

func on_play_anim(node_id, anim_name, reset):
	emit_signal("play_anim", node_id, anim_name, reset)

func var_changed(var_name):
	emit_signal("var_changed", var_name)

## parse text like in renpy to bbcode
func text_passer(text):
	return $Text.text_passer(text, variables)

## add/overwrite global variable that Ren will see
## and returns it as RenVar for easy use
func define(var_name, value = null):
	$Def.define(variables, var_name, value)
	var_changed(var_name)
	return get_var(var_name)

## add/overwrite global variable, from string, that Ren will see
func define_from_str(var_name, var_str, var_type):
	$Def.define_from_str(variables, var_name, var_str, var_type)
	var_changed(var_name)
	return get_var(var_name)

## returns exiting Ren variable as RenVar for easy use
func get_var(var_name):
	var v = _VAR.new()
	v._name = var_name
	return v

## to use with `define_from_str` func as var_type arg
func get_type(variable):
	return $Def.get_type(variable)

## returns variable defined using define
func get_value(var_name):
	return variables[var_name].value

## returns type of variable defined using define
func get_value_type(var_name):
	return variables[var_name].type
	
## crate new charater as global variable that Ren will see
## possible kwargs: name, color, what_prefix, what_suffix, kind, avatar
func character(character_id, kwargs, node = null):
	if node == null:
		node = get_character(character_id)
	node.set_kwargs(kwargs)
	$Def.define(variables, character_id, node, "character")
	return node

func get_character(character_id):
	return _CHR.new(character_id)

## crate new link to node as global variable that Ren will see
func node_link(node, node_id = node.name):
	var path
	if typeof(node) == TYPE_NODE_PATH:
		path = node
		
	elif node is Node:
		path = node.get_path()
	
	$Def.define(variables, node_id, path, "node")
# 	return get_node(node)

# func get_node(node_id):
# 	var p = get_var(node_id).v
# 	return get_node(p)

## add/overwrite global subquest that Ren will see
## and returns it as RenSubQuest for easy use
## possible kwargs: "who", "title", "description", "optional", "state", "subquests"
func subquest(var_name, value = {}):
	var sq = _SUBQ.new()
	$Def.define(variables, var_name, sq, "subquest")
	sq.dict2subquest(value)
	sq.quest_id = var_name
	return sq

## returns exiting Ren subquest as RenSubQuest for easy use
func get_subquest(var_name):
	return variables[var_name].value

## add/overwrite global quest that Ren will see
## and returns it as RenQuest for easy use
## possible kwargs: "who", "title", "description", "optional", "state", "subquests"
func quest(var_name, value = {}):
	var q = _QUEST.new()
	$Def.define(variables, var_name, q, "quest")
	q.dict2quest(value)
	q.quest_id = var_name
	quests.append(var_name)
	return q

## returns exiting Ren quest as RenQuest for easy use
func get_quest(var_name):
	return variables[var_name].value

func _set_statement(node, kwargs):
	node.set_kwargs(kwargs)
	node.exec()

## statement of type say
## there can be only one say, ask or menu in story_state
## its make given character(who) talk (what)
## with keywords : who, what, kind
func say(kwargs):
	_set_statement($Say, kwargs)

## statement of type ask
## there can be only one say, ask or menu in story_state
## its allow player to provide keybord ask that will be assain to given variable
## it also will return RenVar variable
## with keywords : who, what, kind, variable, value
func ask(kwargs):
	_set_statement($Ask, kwargs)
	return get_var(kwargs.variable)

## statement of type menu
## there can be only one say, ask or menu in story_state
## its allow player to make choice
## with keywords : who, what, kind, choices, mkind
func menu(kwargs):
	_set_statement($Menu, kwargs)

## it show custom ren node or charater
## 'state' arg is using to set for example current emtion or/and cloths
## 'state' example '['happy', 'green uniform']'
## with keywords : x, y, z, at, pos
## x, y and pos will use it as procent of screen if between 0 and 1
## "at" is lists that can have: "top", "center", "bottom", "right", "left"
func show(node_id, state = [], kwargs = {"at":["center", "bottom"]}):
	kwargs["node_id"] = node_id
	kwargs["state"] = state
	_set_statement($Show, kwargs)

## statement of type hide
func hide(node_id):
	var kwargs = {"node_id":node_id}
	_set_statement($Hide, kwargs)

## statement of type notify
func notifiy(info, length=5):
	var kwargs = {"info": info,"length":length}
	_set_statement($Notify, kwargs)

## statement of type play_anim
## it will play animation with anim_name form RenAnimPlayer with given node_id
## and by default is reset to 0 pos on exit from statment
func play_anim(node_id, anim_name, reset = true):
	var kwargs = {
		"node_id":node_id,
		"anim_name":anim_name,
		"reset":reset
	}
	_set_statement($PlayAnim, kwargs)

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


func savefile(save_name = "quick"):
	$Persistence.folder_name = save_folder
	$Persistence.password = save_password

	var data = $Persistence.get_data(save_name)
	prints("get data from:", save_name)
	if data == null:
		return false

	data["history"] = history.duplicate()

	var vars_to_save = {}
	for i in range(variables.size()):
		var k = variables.keys()[i]
		var v = variables.values()[i]
		
		if debug_on:
			prints(k, v)
		
		if v.type == "character":
			vars_to_save[k] = {"type":v.type, "value":inst2dict(v.value)}
		elif v.type == "subquest":
			vars_to_save[k] = {"type":v.type, "value":v.value.subquest2dict()}
		elif v.type == "quest":
			vars_to_save[k] = {"type":v.type, "value":v.value.quest2dict()}
		else:
			vars_to_save[k] = v
		
	data["variables"] = vars_to_save

	data["id"] = current_id
	data["local_id"] = local_id
	data["scene"] = _scene
	data["dialog_name"] = current_dialog_name
	data["state"] = prev_story_state #_get_story_state() # it must be this way
	
	var result = $Persistence.save_data(save_name)
	prints("save data to:", save_name)
	return result
	
func loadfile(save_name = "quick"):
	loading_in_progress = true
	$Persistence.folder_name = save_folder
	$Persistence.password = save_password
	
	var data = $Persistence.get_data(save_name)
	prints("load data from:", save_name)
	if data == null:
		return false
	
	quests.clear()
	history = data["history"].duplicate()

	var vars_to_load = data["variables"].duplicate()

	for i in range(vars_to_load.size()):
		var k = vars_to_load.keys()[i]
		var v = vars_to_load.values()[i]

		if debug_on:
			prints(k, v)
		
		if v.type == "character":
			var properties = v.value
			var obj = variables[k].value

			for i in range(properties.size()):
				var pk = properties.keys()[i]
				var pv = properties.values()[i]
				
				if pk in obj.get_property_list():
					obj.set(pk, pv)
		
		elif v.type == "subquest":
			var subq = _SUBQ.new()
			subq.dict2subquest(v.value)
			variables[k] = {"type":v.type, "value":subq}
		
		elif v.type == "quest":
			var q = _QUEST.new()
			q.dict2subquest(v.value)
			variables[k] = {"type":v.type, "value":q}
			if k in quests:
				continue
			quests.append(k)
		
		else:
			variables[k] = v

		var_changed(k)
	
	for q_id in quests:
		var q = get_quest(q_id)
		q.subquests = q.get_subquests(q.subquests)
	
	started = true
	jump(data["scene"], data["dialog_name"], data["state"], true, true)

	current_id = data["id"]
	local_id = data["local_id"]

	return true

func debug(kwargs, kws = [], some_custom_text = ""):
	if !debug_on:
		return

	var dbg = ""
	
	for k in kws:
		if k in kwargs:
			if not(k in [null, ""]):
				dbg += k + " : " + str(kwargs[k]) + ", "
	
	if kws.size() > 0:
		dbg.erase(dbg.length() - 2, 2)

	dbg = some_custom_text + dbg
	return dbg

func _set_current_id(value):
	current_id = value
	local_id = value

func _get_current_id():
	return current_id


## use this to change/assain current scene and dialog
## root of path_to_scene is scenes_dir
## provide path_to_scene with out ".tscn"
func jump(
	path_to_scene,
	dialog_name,
	state = "start",
	change = true,
	from_save = false):

	if not from_save and loading_in_progress:
		return

	local_id = 0
	current_dialog_name = dialog_name
	
	_set_story_state(state) # it must be this way
	
	if from_save:
		_scene = path_to_scene
	else:
		_scene = scenes_dir + path_to_scene + ".tscn"
	
	if debug_on:
		prints("jump to scene:", _scene, "with dialog:", dialog_name, "from:", state)

	if change:
		if current_node != null:
			current_node.queue_free()
		
		var lscene = load(_scene)
		current_node = lscene.instance()
		get_tree().get_root().add_child(current_node)

	if loading_in_progress:
		loading_in_progress = false
	
	if started:
		Ren.story_step()

# Data related to the framework configuration.
func config_data():
	$Persistence.folder_name = FOLDER_CONFIG_NAME
	var config = $Persistence.get_data(FILE_CONFIG_NAME)
	
	# If not have version data, data not exist.
	if not config.has("Version"):
		# Create config data
		
		# This is useful in the case of updates.
		config["Version"] = 1 # Integer number
		# Continue in the last scene the player played
		config["ResumeScene"] = null # First start don't have resume scene
		
		# Maybe we can put here the preferences :D
	
		$Persistence.save_data(FILE_CONFIG_NAME)

func current_statement_in_global_history():
	var hi_item = {
		"state": story_state,
		"statement":{
			"type": current_statement.type,
			"kwargs": current_statement.kwargs
		}
	}

	return hi_item in global_history

func cant_auto():
	return not(current_statement.type in skip_types)

func cant_skip():
	var not_seen = not(Ren.current_statement_in_global_history())
	return cant_auto() and not_seen

func cant_qload():
	var path = str("user://", Ren.save_folder, "/quick")
	return !file.file_exists(path + ".save") or !file.file_exists(path + ".txt")

func save_global_history():
	var save_name = "global_history"
	$Persistence.folder_name = save_folder
	$Persistence.password = save_password

	var data = $Persistence.get_data(save_name)
	prints("get global_history from:", save_name)
	if data == null:
		return false

	data["global_history"] = global_history.duplicate()
	
	var result = $Persistence.save_data(save_name)
	prints("save global_history to:", save_name)
	return result

func load_global_history():
	var save_name = "global_history"
	$Persistence.folder_name = save_folder
	$Persistence.password = save_password
	global_history = []
	var data = $Persistence.get_data(save_name)
	prints("load global_history from:", save_name)
	if data == null:
		return false
	
	if "global_history" in data:
		global_history = data["global_history"].duplicate()
	return true

