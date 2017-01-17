## This is Ren'GD API ##
## Ren'GD is Ren'Py for Godot ##
## version: 0.05 ##
## License MIT ##
## Copyright (c) 2016 Jeremi Biernacki ##

extends VBoxContainer

var how
var what

onready var ren = get_node("/root/Window")

func use_renpy_format(use = true):

    if use:
        how = ren.say_passer(how)
        what = ren.say_passer(what)


func say():
    ren.namebox_screen.set_bbcode(how)
    ren.dialog_screen.set_bbcode(what)
        
    ren.dialog_screen.show()
    ren.input_screen.hide()