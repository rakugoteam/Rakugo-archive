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

signal use_statement(type, id, kwargs)
signal next_statement(id, kwargs)

func define(name, value = null):
	# add global value that ren will see
	_def.define(values, name, value)

func character(val_name, kwargs):
	# crate  new  charater as  global value that ren will see
	# possible kwargs: name, color, what_prefix, what_sufifx, kind, avatar
	var new_ch = _CHR.new()
	new_ch.set_kwargs(kwargs)
	define(val_name, new_ch)

func _init_statement(statement, kwargs):
	statement.ren = self
	statement.kwargs = kwargs
	statements.append(statement)
	statement.id = statements.rfind(statement)

func say(kwargs):
	## crate statement of type say
	## with keywords : how, what
	_init_statement(_SAY.new(),  kwargs)

func input(kwargs):
	## crate statement of type input
	## with keywords : how, what, temp, value
	_init_statement(_INP.new(),  kwargs)



