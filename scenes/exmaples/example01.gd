## This is Ren'GD example scene script##
## Ren'GD is Ren'Py for Godot ##
## version: 0.05 ##
## License MIT ##
## Copyright (c) 2016 Jeremi Biernacki ##

extends Node2D

## it's how import rengd framework if res://scenes/gui/Window.tscn is loaded as singleton
onready var ren = get_node("/root/Window") 

var version = "v 0.05"

var another_time = false

func _ready():
	if not another_time:
		another_time = true
		first()
		

func first():
	ren.label("example01", "res://scenes/exmaples/example01.tscn", "first")
	## It add this scene func to know labels
	## It allows later to easy swich between scenes and thier labels
	## It allows also to reuse scene with different labels
	## using: ren.jump(label_name, [func_args_if_any])
	## You must labeled func before 'jumping' to it!
	
	ren.set_label_current_label("example01")
	## beacose it is first label in game I must write above method to get next things work

	ren.define("guest") ## it add 'guest' var to 'defs' dict that will be saved
	ren.input(ren.defs.guest, "What is your name?")
	## ren.input will set guest var as what you type after pressing enter key
	## It use renpy markup format iI discribed it more under first use of ren.say

	var guest = ren.defs['guest'] ## it must done this way for now
	ren.say("Jeremi360",
			"""Hi! My name is Jeremi360.
				Welcome [guest] to Ren'GD [version] example scene.
				Press MLB, Enter or Space to continue.""")
	## It will set 'Jeremi360' in root/Window/Say/NameBox and second arg in root/Window/Say/Dialog
	## It has markup format like in Ren'Py it means that all godot bbcode '[]' become '{}'
	## '[guest]' will add guest var to your string and do the same for version var
	## you can disabled it set 3rd argumet as 'false'

	var ex_path = "res://scenes/examples/example01"
	ren.say("Jeremi360", 
			"""It's end for now to see how it is done see:
			- [ex_path].gd
			- [ex_path].tscn""")
	
	


