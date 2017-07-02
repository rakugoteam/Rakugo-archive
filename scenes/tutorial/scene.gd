## This is Ren'GD tutorial script ##
## Ren'GD is Ren'Py for Godot ##
## version: 0.7 ##
## License MIT ##

extends "res://scripts/RenGD/ren_short.gd"

var tscn_path

func _ready():
	tscn_path = get_parent().tscn_path
	talk("scene", tscn_path, get_path(), 'scene')


func scene():
	pass

	
