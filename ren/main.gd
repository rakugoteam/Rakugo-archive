## This is Ren API ##

## version: 0.2.0 ##
## License MIT ##

## Main Ren class ## 

extends Control

var statements = []
var local_statements = []
var current_statemnet_id = -1
var current_block_id = -1
var values = {}

const _DEF = preload("def.gd")
onready var _def = _DEF.new()
const _CHR = preload("character.gd")
const _SAY = preload("say_statement.gd")
const _INP = preload("input_statement.gd")

signal enter_statement(type, kwargs)
signal exit_statement(kwargs)

# add global value that ren will see
func define(name, value = null):
	_def.define(values, name, value)

# crate  new  charater as  global value that ren will see
# possible kwargs: name, color, what_prefix, what_suffix, kind, avatar
func character(val_name, kwargs):
	var new_ch = _CHR.new()
	new_ch.set_kwargs(kwargs)
	_def.define(values, val_name, new_ch, "character")

func _init_statement(statement, kwargs, local = false):
	statement.ren = self
	statement.set_kwargs(kwargs)
	current_statemnet_id += 1
	statement.id = current_statemnet_id

	if not local:
		statements.append(statement)
		
	else:
		local_statements.append(statement)

	return statement

## create statement of type say
## with keywords : how, what
func say(kwargs, local = false):
	return _init_statement(_SAY.new(), kwargs, local)

## crate statement of type input
## with keywords : how, what, input_value, value
func input(kwargs, local = false):
	return _init_statement(_INP.new(), kwargs, local)

## crate statement of type menu
## with keywords : how, what, title
func menu(kwargs):
	var title
	if "title" in kwargs:
		title = kwargs.title
		kwargs.erase("title")

	return _init_statement(_MENU.new(title), kwargs)

## crate statement of type choice
## with keywords : how, what
func choice(kwargs):
	return _init_statement(_CHO.new(), kwargs)

# ToDo
# kwgars = {"block_id":-1, "statement_id":-1, "dialog":current_dialog}
# local statements will be add to main statements list as jump statements
# it go dialog => if block_id > -1:
#		=> statments[block_id].statements[statement_id]
#	else:
#		=> tatements[statement_id]
func jump(kwargs):
	pass

## it starts current ren dialog
func start():
	current_block_id = -1
	current_statemnet_id = 0
	using_passer = false
	statements[0].enter()

func _exit_tree():
	for val in values.values():
		if val.type == "Character":
			val.value.free()
	
	_def.free()
	
	for statement in statements:
		statement.free()
		
	

