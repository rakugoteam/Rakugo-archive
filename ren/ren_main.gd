## This is Ren API ##

## version: 0.1.0 ##
## License MIT ##

## Main Ren class ## 

extends Control

var statements = []
var values = {}

const _SAY = preload("say_statement.gd")

signal use_statement(type, id, kwargs)
signal next_statement(id)

func say(kwargs):
	## crate statement of type say
	## with keywords : how, what
	var s = _SAY.new()
	s.ren = self
	s.kwargs = kwargs
	statements.append(s)
	s.id = statements.rfind(s)

func _ready():
	# statements[0].use()
	pass
