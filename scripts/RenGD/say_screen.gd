
extends Control

# This is Ren'GD API
# version: 0.0.1

var _bbcode = ""

onready var _ren = get_node("/root/ren_basic")
onready var _say_screen = get_node("VBoxContainer/Dialog")
onready var _namebox_screen = get_node("VBoxContainer/NameBox/Label")
onready var _ren_input = get_node("VBoxContainer/Input")

var mat = 12 + 34

func _ready():
	_test()
	pass

func _test():
	_ren.define("mat", mat)
	print(_ren.vars)
	say("developer", "This is {b}just{/b} a {i}test{/i} [mat].")

func say(how, what):
	_say_screen.show()
	_ren_input.hide()

	_bbcode = _ren.str_passer(how)
	_namebox_screen.set_bbcode(_bbcode)

	_bbcode = _ren.str_passer(what)
	_say_screen.set_bbcode(_bbcode)
