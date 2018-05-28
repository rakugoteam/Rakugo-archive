extends Node

var history = [] # [{"state":story_state, "statement":{"type":type, "kwargs": kwargs}}]
var current_statement = null
var current_menu
var current_id = 0 setget _set_current_id, _get_current_id
var local_id = 0


var values = {
	"version":{"type":"text", "value":"0.7.0 GDScript"},
	"test_bool":{"type":"var", "value":false},
	"test_float":{"type":"var", "value":10},
	"story_state":{"type":"text", "value":""}
	}

var using_passer = false
var current_dialog_name = ""
var skip_auto = false

export(bool) var debug_inti = true

const _CHR	= preload("nodes/character.gd")
onready var timer = $Timer

var story_state setget _set_story_state, _get_story_state

signal exec_statement(type, kwargs)
signal exit_statement(previous_type, kwargs)
signal notified()
signal show(node_id, state, show_args)
signal hide(node_id)
signal val_changed(val_name)
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

func val_changed(val_name):
	emit_signal("val_changed", val_name)

## parse text like in renpy to bbcode
func text_passer(text):
	return $Text.text_passer(text, values)

## add/overwrite global value that Ren will see
func define(val_name, value = null):
	$Def.define(values, val_name, value)
	val_changed(val_name)

## add/overwrite global value, from string, that Ren will see
func define_from_str(val_name, val_str, val_type):
	$Def.define_from_str(values, val_name, val_str, val_type)
	val_changed(val_name)

## to use with `define_from_str` func as val_type arg
func get_type(val):
	return $Def.get_type(val)

## returns value defined using define
func get_value(val_name):
	return values[val_name].value

## returns type of value defined using define
func get_value_type(val_name):
	return values[val_name].type
	
## crate new charater as global value that Ren will see
## possible kwargs: name, color, what_prefix, what_suffix, kind, avatar
func character(val_name, kwargs, node = null):
	node.set_kwargs(kwargs)
	$Def.define(values, val_name, node, "character")

## crate new link to node as global value that Ren will see
func node_link(node, node_id = node.name):
	if typeof(node) == TYPE_NODE_PATH:
		$Def.define(values, node_id, node)
		
	elif node is Node:
		$Def.define(values, node_id, node, "node")

func _set_statement(node, kwargs):
	node.set_kwargs(kwargs)
	node.exec()

## statement of type say
## there can be only one say, input or menu in story_state
## its make given character(who) talk (what)
## with keywords : who, what, kind
func say(kwargs):
	_set_statement($Say, kwargs)

## statement of type input
## there can be only one say, input or menu in story_state
## its allow player to provide keybord input that will be assain to given value
## with keywords : who, what, kind, input_value, value
func input(kwargs):
	_set_statement($Input, kwargs)

## statement of type menu
## there can be only one say, input or menu in story_state
## its allow player to make choice
## with keywords : who, what, kind, choices, mkind
func menu(kwargs):
	# if not ("mkind" in kwargs):
	# 	kwargs["mkind"] = "vertical"
		
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
	return get_value("story_state")

## it starts current Ren dialog
func start(dialog_name, state):
	current_menu = null
	using_passer = false
	current_id = 0
	# jump(dialog_name, state) - don't works :(
	set_meta("playing", true) # for checking if Ren is playing

func jump(dialog_name, state):
	current_dialog_name = dialog_name
	story_state = state
	local_id = 0
	Ren.story_step()

func savefile(filepath="user://save.dat", password="Ren"):
	pass
	
func loadfile(filepath="user://save.dat", password="Ren"):
	pass

func debug(kwargs, kws = [], some_custom_text = ""):
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