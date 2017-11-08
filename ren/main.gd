## This is Ren API ##

## version: 0.2.0 ##
## License MIT ##

## Main Ren class ## 

extends Control

var statements = []
var values = {}
var current_menu
var current_indentation = 0
var using_passer = false
var current_block_type = "none"
var previous_block_type = "none"

const _DEF  = preload("def.gd")
const _CHR  = preload("character.gd")
const _SAY  = preload("say_statement.gd")
const _INP  = preload("input_statement.gd")
const _MENU = preload("menu_statement.gd")
const _CHO	= preload("choice_statement.gd")
const _END	= preload("end_statement.gd")

onready var _def = _DEF.new()

signal enter_statement(type, kwargs)
signal exit_statement(kwargs)

# add global value that ren will see
func define(name, value = null, val_type = null):
	_def.define(values, name, value, val_type)

# crate new charater as global value that ren will see.
# possible kwargs: name, color, what_prefix, what_suffix, kind, avatar
func character(val_name, kwargs):
	var new_ch = _CHR.new()
	new_ch.set_kwargs(kwargs)
	new_ch.debug()
	_def.define(values, val_name, new_ch, "character", false)

func _init_statement(statement, kwargs):
	statement.ren = self
	statement.set_kwargs(kwargs)
	statements.append(statement)
	statement.id = statements.rfind(statement)
	statement.ren_init()

## create statement of type say
## with keywords : how, what
func say(kwargs):
	_init_statement(_SAY.new(), kwargs)

## crate statement of type input
## with keywords : how, what, input_value, value
func input(kwargs):
	_init_statement(_INP.new(), kwargs)

## crate statement of type menu
## with keywords : how, what, title
func menu(kwargs):
	var title
	if "title" in kwargs:
		title = kwargs.title
		kwargs.erase("title")

	previous_block_type = current_block_type
	current_block_type = "menu"
	_init_statement(_MENU.new(title), kwargs)

## crate statement of type choice
## with keywords : how, what
func choice(kwargs):
	previous_block_type = current_block_type
	current_block_type = "choice"
	_init_statement(_CHO.new(), kwargs)

## crate statement of type end
## with keywords : indentation_delta
func end(kwargs = {}):
	var indentation_delta = 1
	if " indentation_delta" in kwargs:
		 indentation_delta = kwargs. indentation_delta
		 kwargs.erase(" indentation_delta")

	_init_statement(_END.new(indentation_delta), kwargs)

func start():
	current_menu = null
	current_indentation = 0
	using_passer = false
	current_block_type = "none"
	previous_block_type = "none"
	statements[0].enter()

func _exit_tree():
	for val in values.values():
		if val.type == "character":
			val.value.free()
	
	_def.free()
	
	for statement in statements:
		statement.free()
		
	

