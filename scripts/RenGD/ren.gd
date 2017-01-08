
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

# var characters = []
var objects = []
# var labels = []
var vars = {}

var _is_input_on = false
var _input_var

func _ready():
    _input_screen.connect("text_entered", self, "_on_input")

func define(var_name, var_value):
    vars.var_name = var_value


func get_var():
    return vars.get_var_name()


class input extends Object:
    func _init(ivar, what, temp):
        temp = str_passer(temp)
        what = str_passer(what)
        ivar = ivar
        
        objects.append(self)

    func show():
        _input.set_text(temp)
        _namebox_screen.set_bbcode(what)

        _say_screen.hide()
        _input.show()
        _input_var = ivar
        _is_input_on = true


func _on_input(s):
    set(_input_var, s)


class say extends Object:
    func _init(how, what):
        how = say_passer(how)
        what = say_passer(what)
       
        objects.append(self)

    func show():
        _namebox_screen.set_bbcode(how)
        _say_screen.set_bbcode(what)
        
        _say_screen.show()
        _input.hide()

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
