## This is Ren'GD API ##

## version: 0.1.0 ##
## License MIT ##

## Main Ren class ## 

extends Control

##							###
###	Say statement import	###
###							###

const _SAY = preload("say_statement.gd")
onready var _say = _SAY.new()

func text_passer(text = "", values = {}):
	## passer for renpy markup format
	## its retrun bbcode
	return ren_txt.text_passer(values, text)

signal use_statemnet(type, kwargs)

var statments = []
var values = {}


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
