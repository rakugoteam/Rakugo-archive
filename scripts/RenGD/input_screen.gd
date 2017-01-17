## This is Ren'GD API ##
## Ren'GD is Ren'Py for Godot ##
## version: 0.05 ##
## License MIT ##
## Copyright (c) 2016 Jeremi Biernacki ##

extends LineEdit

var temp
var what
var ivar
var _input_var
var _is_input_on

onready var ren = get_node("/root/Window")


func _ready():
    connect("text_entered", self, "_on_input")


func use_renpy_format(use = true):

    if use:
        temp = ren.say_passer(temp)
        what = ren.say_passer(what)


func input():
    set_text(temp)
    ren.namebox_screen.set_bbcodes(what)

    ren.say_screen.hide()
    show()
    _input_var = ivar
    _is_input_on = true


func _on_input(s):
    set(_input_var, s)
    _is_input_on = true