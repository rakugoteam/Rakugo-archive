## This is Ren API ##

## version: 0.2.0 ##
## License MIT ##

## Main Ren class ## 

extends Control

var statements = []
var current_statement_id = -1
var current_local_statement_id = -1
var current_block = []
var current_menu
var choice_id = -1
var values = {}
var using_passer = false
export(bool) var debug_inti = true

const _DEF = preload("def.gd")
const _CHR = preload("character.gd")
const _SAY = preload("say_statement.gd")
const _INP = preload("input_statement.gd")
const _JMP = preload("jump_statement.gd")
const _MENU = preload("menu_statement.gd")
const _CHO = preload("choice_statement.gd")

onready var _def = _DEF.new()

signal enter_statement(type, kwargs)
signal enter_block(kwargs)
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

func _init_statement(statement, kwargs, condition_statement = null):
	statement.ren = self
	statement.set_kwargs(kwargs)
	
	if debug_inti:
		statement.debug(statement.kws, "condition_statement: " + str(condition_statement) + ", ")
		
	if condition_statement != null:
		current_block = condition_statement
		statement.condition_statement = condition_statement
		
		if condition_statement.type == "menu":
			current_local_statement_id = -1
			choice_id += 1
			statement.id = choice_id
			condition_statement.choices.append(statement)
			
		else:
			choice_id = -1
			current_local_statement_id += 1
			statement.id = current_local_statement_id
			condition_statement.statements.append(statement)
			
	else:
		choice_id = -1
		current_local_statement_id = -1
		current_statement_id += 1
		statement.id = current_statement_id
		statements.append(statement)

	return statement


## create statement of type say
## with keywords : how, what
func say(kwargs, condition_statement = null):
	return _init_statement(_SAY.new(), kwargs, condition_statement)

## crate statement of type input
## with keywords : how, what, input_value, value
func input(kwargs, condition_statement = null):
	return _init_statement(_INP.new(), kwargs, condition_statement)

## crate statement of type menu
## with keywords : how, what, title
func menu(kwargs, condition_statement = null):
	var title = null
	if "title" in kwargs:
		title = kwargs.title
		kwargs.erase("title")

	return _init_statement(_MENU.new(title), kwargs, condition_statement)


## crate statement of type choice
## with keywords : how, what
func choice(kwargs, menu):
	return _init_statement(_CHO.new(), kwargs, menu)

## create statement of type jump
## with keywords : dialog, block, statement_id
func jump(kwargs, condition_statement = null):
	return _init_statement(_JMP.new(), kwargs, condition_statement)

## it starts current ren dialog
func start():
	current_block = []
	current_menu = []
	current_statement_id = 0
	current_local_statement_id = -1
	choice_id = -1
	using_passer = false
	statements[0].enter()


