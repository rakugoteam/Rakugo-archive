## This is Ren'GD API ##
## Ren'GD is Ren'Py for Godot ##
## version: 0.05 ##
## License MIT ##
## Copyright (c) 2016 Jeremi Biernacki ##

extends VBoxContainer

var how
var what

onready var ren = get_node("/root/Window")
onready var dialog_screen = get_node("Dialog")
onready var namebox_screen = get_node("NameBox/Label")

func use_renpy_format(use = true):

    if use:
        how = ren.say_passer(how)
        what = ren.say_passer(what)


func say():
    namebox_screen.set_bbcode(how)
    dialog_screen.set_bbcode(what)
    dialog_screen.show()