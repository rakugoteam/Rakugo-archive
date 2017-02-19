## This is Ren'GD example scene script##
## Ren'GD is Ren'Py for Godot ##
## version: 0.6 ##
## License MIT ##


extends Node2D

## it's how import rengd framework when res://scenes/gui/Window.tscn is loaded as singleton
onready var ren = get_node("/root/Window") 

var another_time = false

func _ready():

	# if not another_time:
	# 	another_time = true
	# 	first()

	first()
	
	ren.start_ren()
	## This must be at end of code.
	## this start ren "magic" ;)
	

func first():
	var tscn_path = "res://scenes/tutorial_2d_api/tutorial_2d_api.tscn"
	ren.label("tutorial_2d_api", tscn_path, "first")
	## It add this scene func to know labels
	## It allows later to easy swich between scenes and thier labels
	## It allows also to reuse scene with different labels
	## using: ren.jump(label_name, [func_args_if_any])
	## You must labeled func before 'jumping' to it!
	
	## ren.set_label_current_label("tutorial_2d_api")
	## beacose it is first label in game I must write above method to get next things work

	ren.define("guest") ## it add 'guest' var to 'keywords' dict that is global and will be saved
	ren.append_input("guest", "What is your name?", "Godot Developer")
	## ren.append_input will set guest var as what you type after pressing enter key
	## It use renpy markup format iI discribed it more under first use of ren.say
	

	ren.append_say("Jeremi360",
			"""Hi! My name is Jeremi360.
			Welcome [guest] to Ren'GD [version] example scene.
			Press MLB, Enter or Space to continue.""")
	## It will set 'Jeremi360' in root/Window/Say/NameBox and second arg in root/Window/Say/Dialog
	## It has markup format like in Ren'Py it means that all godot bbcode '[]' become '{}'
	## '[guest]' will add guest var to your string and do the same for version var
	## you can disabled it set 3rd argumet as 'false'

	var first_choice = [ren.say("Jeremi360","This is Ren'Py for Godot.")]
	
	var long_txt = "Becose you can make stuff like anims and gui faster and easier using Godot Editor."
	var second_choice = [ren.say("Jeremi360", long_txt),#]
						ren.say("Jeremi360", "You can use 3D models in your visual novel."),
						ren.say("Jeremi360","Also is easier to make mini games this why.")
						]
	# second_choice.append(ren.say("Jeremi360", "You can use 3D models in your visual novel."))
	# second_choice.append(ren.say("Jeremi360","Also is easier to make mini games this why."))


	var choices = {
		"What is Ren'GD?": first_choice,
		"Why use it instead of Ren'Py?": second_choice
	}

	ren.append_menu(choices, "What you want to know?")

	ren.define("ex_path", tscn_path)
	ren.append_say("Jeremi360", 
			"""It's end for now to see how it is done see:
			{list}- [ex_path].gd
			{list}- [ex_path].tscn""")
	
	
	


