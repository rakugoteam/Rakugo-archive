## This is Ren'GD example say script##
## Ren'GD is Ren'Py for Godot ##
## version: 0.7 ##
## License MIT ##

extends "res://scripts/RenGD/ren_short.gd"

var tscn_path = get_tree().get_root().tscn_path

func _ready():
    talk("say", tscn_path, get_path_to(self), 'talk_say')
    talk("input", tscn_path, get_path_to(self), 'talk_input')


func talk_say():
	pass


func talk_input():
    pass
	
