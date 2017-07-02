## This is Ren'GD example menu script##
## Ren'GD is Ren'Py for Godot ##
## version: 0.7 ##
## License MIT ##

extends "res://scripts/RenGD/ren_short.gd"

var tscn_path = get_tree().get_root().tscn_path

func _ready():
	talk("menu", tscn_path, get_path_to(self), '_menu')


func _menu():
	pass

	
