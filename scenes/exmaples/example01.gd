## This is Ren'GD example scene script##
## Ren'GD is Ren'Py for Godot ##
## version: 0.04 ##
## License MIT ##
## Copyright (c) 2016 Jeremi Biernacki ##

extends Node2D

## it's how import rengd framework if res://scenes/gui/Window.tscn is loaded as singleton
onready var ren = get_node("/root/Window") 

var version = "v 0.04"

var another_time = false

func _ready():
	if not another_time:
		first()
		another_time = true

func first():
	ren.label(label_name = "example01", 
				scene_path = "res://scenes/exmaples/example01.tscn",
				func_name = "first")
	## It add this scene func to know labels
	## It allows later to easy swich between scenes and thier labels
	## It allows also to reuse scene with different labels
	## using: ren.jump(label_name, func_args_if_any)
	## You must labeled func before 'jumping' to it!

	ren.define("guest") ## it add 'guest' var to 'defs' dict that will be saved
	var i = ren.input(ren.defs.guest, "What is your name?")
	## ren.input will set guest var as what you type after pressing enter key
	## It use renpy markup format iI discribed it more under first use of ren.say
	
	i.show()
	## It will really 'run'/'show' ren.input on your screen 
	## I must provide 'show' to make possible implement to scrollback words story
	## like in orignal Ren'Py

	var guest = ren.defs['guest'] ## it must done this way for now
	var s = ren.say(
					_how = "Jeremi360", 
					_what = "Hi! My name is Jeremi360. Welcome [guest] to Ren'GD [version] example scene.
							Press MLB, Enter or Space to continue."
					)
	## It will set '_how' in root/Window/Say/NameBox and '_what' in root/Window/Say/Dialog
	## It has markup format like in Ren'Py it means that all godot bbcode '[]' become '{}'
	## '[guest]' will add guest var to your string and do the same for version var
	## you can disabled it set 3rd argumet as 'false'
	
	s.show()
	## Again use of 'show' - the same reason like in 'ren.input' case

	var ex_path = "res://scenes/examples/example01"
	s = ren.say(
				"Jeremi360",
				"It's end for now to see how it is done see:
				 	- [ex_path].gd
					- [ex_path].tscn"
				)
	
	


