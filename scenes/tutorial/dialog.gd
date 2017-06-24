## This is Ren'GD example say script##
## Ren'GD is Ren'Py for Godot ##
## version: 0.7 ##
## License MIT ##

extends "res://scripts/RenGD/ren_short.gd"

var tscn_path = "res://scenes/tutorial/tutorial.tscn"

func _ready():
	label("say", tscn_path, get_path_to(self), '_say')
    label("input", tscn_path, get_path_to(self), '_linput')


func _say():
	pass


func _linput():
    pass
	
