
extends Control

# This is Ren'GD API
# version: 0.01
var _bbcode = ""
var _say_path = "VBoxContainer/"
onready var _say_screen = get_node(say_path + "Dialog")
onready var _namebox_screen = get_node(say_path + "NameBox/Label")
onready var _input = get_node(say_path + "EditText")

func _ready():
	say("developer", "This is {b}just{/b} a {i}test{/i} [12+34].")

func input(what, temp):
	_say_screen.clear()
	_say_screen.set_hidden(True)
	_namebox_screen.clear()

	_input.clear()
	_input.set_hidden(False)

	_bbcode = sentence_passer(temp)

	_input.set_bbcode(_bbcode)

	_bbcode = sentence_passer(what)
	_namebox_screen.set_bbcode(_bbcode)

	return _input.get_bbcode()


func say(how, what):
	#print("clear say screen")
	_say_screen.clear()
	_say_screen.set_hidden(False)
	_namebox_screen.clear()

	#print("setting say screen text")
	_bbcode = sentence_passer(how)
	_namebox_screen.set_bbcode(_bbcode)

	_bbcode = sentence_passer(what)
	_say_screen.set_bbcode()

func sentence_passer(text):
	#print("parse text")

	var	pstr = ""
	var vstr = ""
	var b = false

	var i = 1

	for t in text:

		if t == "[":
			b = true
			pstr += t

		elif t == "]":
			b = false
			pstr += t
			vstr = var2str(str2var(vstr))
			print(pstr, " ", vstr)
			text = text.replace(pstr, vstr)

		elif b:
			pstr += t
			vstr += t

	text = text.replace("{image", "[img")
	text = text.replace("{", "[")
	text = text.replace("}", "]")

	return text
