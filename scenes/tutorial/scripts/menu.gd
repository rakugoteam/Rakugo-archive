## This is Ren'GD example menu script##

## version: 0.7 ##
## License MIT ##

extends "res://RenGD/ren_short.gd"

var tscn_path

func _ready():
	tscn_path = get_parent().tscn_path
	dialog("menu", tscn_path, get_path(), '_menu')

func _menu():
	pass

	
