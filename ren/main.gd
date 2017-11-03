## This is Ren API ##

## version: 0.1.0 ##
## License MIT ##

## Main Ren class ## 

extends Control

var statements = []
var values = {}


const _DEF = preload("def.gd")
onready var _def = _DEF.new()
const _CHR = preload("character.gd")
const _SAY = preload("say_statement.gd")
const _INP = preload("input_statement.gd")

signal enter_statement(type, kwargs)
signal exit_statement(kwargs)

func define(name, value = null):
	# add global value that ren will see
	_def.define(values, name, value)

func character(val_name, kwargs):
	# crate  new  charater as  global value that ren will see
	# possible kwargs: name, color, what_prefix, what_suffix, kind, avatar
	var new_ch = _CHR.new()
	new_ch.set_kwargs(kwargs)
	_def.define(values, val_name, new_ch, "Character")

func _init_statement(statement, kwargs):
	statement.ren = self
	statement.set_kwargs(kwargs)
	# statements.append(statement)
	# statement.id = statements.rfind(statement)
	statement.use()

func say(kwargs):
	## crate statement of type say
	## with keywords : how, what
	_init_statement(_SAY.new(),  kwargs)

func input(kwargs):
	## crate statement of type input
	## with keywords : how, what, input_value, value
	_init_statement(_INP.new(),  kwargs)

func _exit_tree():
	for val in values.values():
		if val.type == "Character":
			val.value.free()
	
	_def.free()
	
	for statement in statements:
		statement.free()
		
	

