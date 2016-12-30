
extends Node

# This is Ren'GD API
# version: 0.0.1

onready var _say_screen = get_node("/root/Window/Say")
onready var _input_screen = get_node("/root/Window/Say/VBoxContainer/Input")
onready var _choice_screen = get_node("/root/Window/Choice")

# func _ready():
#   print(_choice_screen.get_name())
#   print(_say_screen.get_name())
#   print(_input_screen.get_name())

func say(how, what):
  _say_screen.say(how, what)

func input(ivar, what, temp):
  _input_screen.input(ivar, what, temp)

func choice(items):
  _choice_screen.choice(items)
