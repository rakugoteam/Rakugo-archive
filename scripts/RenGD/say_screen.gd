
extends Control

# This is Ren'GD API
# version: 0.0.1

var _bbcode = ""
var _say_path = "VBoxContainer/"

onready var _ren = get_node("/root/renapiraw")
onready var _say_screen = get_node(_say_path + "Dialog")
onready var _namebox_screen = get_node(_say_path + "NameBox/Label")
onready var _ren_input = get_node(_say_path + "Input")

var itest
var mat = 12 + 34

func _ready():
	_ren.define("mat", mat)
	print(Globals.get("vars"))
	#_test()
	#pass

func _test():
	say("developer", "This is {b}just{/b} a {i}test{/i} [mat].")

func say(how, what):
	_say_screen.show()
	_ren_input.hide()

	_bbcode = _ren.str_passer(how)
	_namebox_screen.set_bbcode(_bbcode)

	_bbcode = _ren.str_passer(what)
	_say_screen.set_bbcode(_bbcode)
