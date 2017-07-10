## This is Ren'GD tutorial script ##

## version: 0.7 ##
## License MIT ##

extends "res://scripts/RenGD/ren_short.gd"

var tscn_path

func _ready():
	tscn_path = get_parent().tscn_path
	dialog("dialog", tscn_path, get_path(), '_dialog')


func _dialog():
	pass

	
