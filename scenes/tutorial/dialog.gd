## This is Ren'GD example say script##
## Ren'GD is Ren'Py for Godot ##
## version: 0.7 ##
## License MIT ##

extends "res://scripts/RenGD/ren_short.gd"

var tscn_path

func _ready():
    tscn_path = get_parent().tscn_path
    dialog("say", tscn_path, get_path(), 'dialog_say')
    dialog("input", tscn_path, get_path(), 'dialog_input')


func dialog_say():
	pass


func dialog_input():
    pass
	
