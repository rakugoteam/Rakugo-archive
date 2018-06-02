extends Node

export (bool) var debug_on = true
export (String) var save_folder = "saves"
export (String) var save_password = "Ren"
export (String, DIR) var scenes_dir = "res://scenes/examples/"

# this must be saved
var current_id = 0 setget _set_current_id, _get_current_id
var local_id = 0
var current_dialog_name = ""
var _scene = null
var history = [] # [{"state":story_state, "statement":{"type":type, "kwargs": kwargs}}]
var variables = {
	"version":{"type":"text", "variable":"0.9.0"},
	"test_bool":{"type":"var", "variable":false},
	"test_float":{"type":"var", "variable":10},
	"story_state":{"type":"text", "variable":""}
}

# don't save this
onready var menu_node = $Menu
var current_statement = null
var using_passer = false
var skip_auto = false
var current_node = null

export(bool) var debug_inti = true

const _CHR	= preload("nodes/character.gd")
onready var timer = $Timer

var story_state setget _set_story_state, _get_story_state

signal exec_statement(type, kwargs)
signal exit_statement(previous_type, kwargs)
signal notified()
signal show(node_id, state, show_args)
signal hide(node_id)
signal var_changed(var_name)
signal story_step(dialog_name)

func _ready():
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

func var_changed(var_name):
	emit_signal("var_changed", var_name)

## parse text like in renpy to bbcode
func text_passer(text):
	return $Text.text_passer(text, variables)

## add/overwrite global variable that Ren will see
func define(var_name, variable = null):
	$Def.define(variables, var_name, variable)
	var_changed(var_name)

## add/overwrite global variable, from string, that Ren will see
func define_from_str(var_name, var_str, var_type):
	$Def.define_from_str(variables, var_name, var_str, var_type)
	var_changed(var_name)

## to use with `define_from_str` func as var_type arg
func get_type(variable):
	return $Def.get_type(variable)

## returns variable defined using define
func get_variable(var_name):
	return variables[var_name].variable

## returns type of variable defined using define
func get_variable_type(var_name):
	return variables[var_name].type
	
## crate new charater as global variable that Ren will see
## possible kwargs: name, color, what_prefix, what_suffix, kind, avatar
func character(var_name, kwargs, node = null):
	node.set_kwargs(kwargs)
	$Def.define(variables, var_name, node, "character")

## crate new link to node as global variable that Ren will see
func node_link(node, node_id = node.name):
	var path
	if typeof(node) == TYPE_NODE_PATH:
		path = node
		
	elif node is Node:
		path = node.get_path()
	
	$Def.define(variables, node_id, path, "node")

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
## with keywords : who, what, kind, ask_variable, variable
func ask(kwargs):
	_set_statement($Ask, kwargs)

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

func _set_story_state(state):
	define("story_state", state)

func _get_story_state():
	return get_variable("story_state")

## it starts Ren
func start():
	using_passer = false
	current_id = 0
	local_id = 0

func savefile(save_name="quick"):
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
		if v.type in ["node", "character"]:
			continue
		else:
			vars_to_save[k] = v
			prints(k, v)
		
	data["variables"] = vars_to_save

	data["id"] = current_id
	data["local_id"] = local_id
	data["scene"] = _scene
	data["dialog_name"] = current_dialog_name
	data["state"] = _get_story_state()
	
	var result = $Persistence.save_data(save_name)
	prints("save data to:", save_name)
	return result
	
func loadfile(save_name="quick"):
	$Persistence.folder_name = save_folder
	$Persistence.password = save_password
	var data = $Persistence.get_data(save_name)
	prints("load data from:", save_name)
	if data == null:
		return false

	history = data["history"].duplicate()

	var vars_to_load = data["variables"].duplicate()

	for i in range(vars_to_load.size()):
		var k = vars_to_load.keys()[i]
		var v = vars_to_load.values()[i]
		variables[k] = v
		prints(k, v)
		var_changed(k)
	
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

func _set_current_id(variable):
	current_id = variable
	local_id = variable

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

	local_id = 0
	current_dialog_name = dialog_name
	_set_story_state(state) # it must be this way
	
	if from_save:
		_scene = path_to_scene
	else:
		_scene = scenes_dir + path_to_scene + ".tscn"

	if debug_on:
		prints("jump to scene:", _scene, "with dialog:", dialog_name, "from:", state)

	if not change:
		return

	current_node.queue_free()
	var lscene = load(_scene)
	current_node = lscene.instance()
	get_tree().get_root().add_child(current_node)
