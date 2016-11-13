
extends Node

# This is Ren'GD API
# version: 0.01
var say_path = "Say/VBoxContainer/"
onready var say_screen = get_node(say_path + "Dialog")
onready var namebox_screen = get_node(say_path + "NameBox/Label")

func _ready():
	say("developer", "This is {b}just{/b} a {i}test{/i}.")

func say(how, what):
	print("clear say screen")
	say_screen.clear()
	namebox_screen.clear()
	
	print("setting say screen text")
	namebox_screen.set_bbcode(sentence_passer(how))
	say_screen.set_bbcode(sentence_passer(what))

func sentence_passer(text):
	print("parse text")
	text = text.replace("{", "[")
	text = text.replace("}", "]")
	return text
	 
