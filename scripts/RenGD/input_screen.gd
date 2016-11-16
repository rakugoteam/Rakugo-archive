
extends Control

# This is Ren'GD API
# version: 0.01
var _bbcode = ""
var _say_path = "../"
var _is_input_on = false
var _input_var

onready var _ren = get_node("/root/renapiraw")
onready var _say_screen = get_node(_say_path + "Dialog")
onready var _namebox_screen = get_node(_say_path + "NameBox/Label")

var itest

func _ready():
	connect("text_entered", self, "_on_input")
	#_test()

func _test():
	input("itest", "test", "type something and press enter")

func input(ivar, what, temp):
	_bbcode = _ren.sentence_passer(temp)
	set_text(_bbcode)

	_bbcode = _ren.sentence_passer(what)
	_namebox_screen.set_bbcode(_bbcode)

	_say_screen.set_hidden(true)
	set_hidden(false)
	_input_var = ivar
	_is_input_on = true

func _on_input(s):
	set(_input_var, s)
	print(itest)
