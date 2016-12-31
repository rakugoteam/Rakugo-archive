
## This is Ren'GD API ##
## Ren'GD is Ren'Py for Godot ##
## version: 0.0.2 ##
## License MIT ##
## Copyright (c) 2016 Jeremi Biernacki ##

extends Node

onready var _choice_screen = get_node("Choice")
onready var _input_screen = get_node("Say/VBoxContainer/Input")
onready var _say_screen = get_node("Say/VBoxContainer/Dialog")
onready var _namebox_screen = get_node("Say/VBoxContainer/NameBox/Label")
onready var _input = get_node("Say/VBoxContainer/Input")

var _characters = []
var _scenes = []
var _nodes = []
var _vars = {}
var _args = []

var quotes = "\""
var apost = "\'"
var lend = "\n"
var tab = "\t"

var _bbcode = ""
var _is_input_on = false
var _input_var


func _ready():
    _input_screen.connect("text_entered", self, "_on_input")

    print("test line passer:")
    var line_code = line_passer("$ self.get_name()")
    print(line_code)
    var line_say_a = line_passer("\"developer\" \"This is just test\"")
    print(line_say_a)

func define(var_name, var_value):
    _vars.var_name = var_value


func get_var():
    return _vars.var_name


func line_passer(line):
    var c_line = line.c_escape()

    var say_pattern_a = "\"someone\" \"Say some thing.\"".c_escape()

    if line.begins_with("$"):
        line = line.replace("$", "")

    elif c_line.begins_with(quotes):
        #or c_line.begins_with(apost):
        line = line + " sim: " + var2str(c_line.similarity(say_pattern_a))

    return line


func input(ivar, what, temp):
    _bbcode = str_passer(temp)
    set_text(_bbcode)

    _bbcode = str_passer(what)
    _namebox_screen.set_bbcode(_bbcode)

    _say_screen.hide()
    show()
    _input_var = ivar
    _is_input_on = true


func _on_input(s):
    set(_input_var, s)


func say(how, what):
    _say_screen.show()
    _input.hide()

    _bbcode = str_passer(how)
    _namebox_screen.set_bbcode(_bbcode)

    _bbcode = str_passer(what)
    _say_screen.set_bbcode(_bbcode)


func say_passer(text):
    var pstr = ""
    var vstr = ""
    var b = false

    for t in text:

    	if t == "[":
    		b = true
    		pstr += t

    	elif t == "]":
    		b = false
    		pstr += t
    		vstr = var2str(_get_var(vstr))
    		text = text.replace(pstr, vstr)

    	elif b:
    		pstr += t
    		vstr += t

    text = text.replace("{image", "[img")
    text = text.replace("{", "[")
    text = text.replace("}", "]")
    
    return text
