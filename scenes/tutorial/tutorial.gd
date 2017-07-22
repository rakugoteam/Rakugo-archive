## This is Ren'GD tutorial script ##

## version: 0.7 ##
## License MIT ##


extends "res://scripts/RenGD/ren_short.gd"

var tscn_path = "res://scenes/tutorial/tutorial.tscn"

func _ready():
	
	dialog("tutorial", tscn_path, get_path())
	## It add this scene func to know dialogs
	## It allows later to easy swich between scenes and thier dialogs
	## It allows also to reuse scene with different dialogs
	## using: jump(dialog_name, [func_args_if_any])
	## You must dialoged func before 'jumping' to it!
	
	set_current_dialog("tutorial")
	## beacose it is first dialog in game I must write above method to get next things work

	define("guest") ## it add 'guest' var to 'keywords' dict that is global and will be saved
	input("guest", "What is your name?", "Godot Developer")
	## input will set guest var as what you type after pressing enter key
	## It use renpy markup format iI discribed it more under first use of say
	
	var jer = Character("Jeremi360", "#25c33e")
	define("jer", jer)
	## This is how you declare a new Character

	# node("jer", get_node("TestAvatar/Normal"))
	# auto_subnodes("jer", get_node("TestAvatar"), "Normal")
	# ## This is how you create shortcuts to different sprites of your character 
	# ren_show("jer Smile")

	# say("jer", "Hi this is how i look.")
	# say("jer", "And now I will hide")
	# ren_hide("jer Smile")

	say("jer",
			"""Hi! My name is [jer.name].
			Welcome [guest] to Ren'GD [version] Tutorial.
			Press MLB, Enter or Space to continue.""")
	## It will set 'Jeremi360' in root/Window/Say/NameBox and second arg in root/Window/Say/Dialog
	## It has markup format like in Ren'Py it means that all godot bbcode '[]' become '{}'
	## '[guest]' will add guest var to your string and do the same for version var

	# var test_list = ["test", "TEST"]
	# define_list("test_list", test_list)
	# say("jer","Test of list [test_list[1]].")

	var topics = [
		"Basic",
		"Say",
		"Character",
		"Input",
		"Menu",
		"Talk",
		"Node",
		"Scene"
	]

	menu(topics, "What you want to know?", self, "topic_choice")

	define("ex_path", tscn_path)
	say("jer", 
			"""It's end for now to see how it is done see:
			{tab}- [ex_path].gd
			{tab}- [ex_path].tscn""")
	
	say("jer", "Goodbye, [guest].")

	do_dialog()
	

func topic_choice(choice):
	before_menu()
	
	# print("Choice is ", choice)
	
	if choice == "Basic":
		# go to other dialog
		jump("basic") 

	elif choice == "Say":
		say("jer", "Say statment/func is make character speaks.")
		say("jer", """The GDScript way to call it is:
								{code}say('how','what'){/code}""")
		say("jer", """The Ren'GD Script way to call it is:
								{code}'how' 'what'{/code} or {code}charcter_var 'what'{/code}""")
								
		# jump("say")

	#if choice == "Character":

	elif choice == "Input":
		say("jer", "Input statment/func is way to provide text input file for player.")
		say("jer", """The GDScript way to call it is:
								{code}input('var','what','temp'){/code}""")
		say("jer", """The Ren'GD Script way to call it is:
								{code}g: input('var','what','temp'){/code}""")
		
		# jump("input")

	# #elif choice == "Menu":
		# jump("menu")

	# #elif choice == "Dialog":
		# jump("dialog")

	# #elif choice == "Node":
		# jump("node")
	
	# #elif choice == "Scene":
		# jump("scene")
	
	else:
		say('', "To be done :(.")
	

	after_menu()
	
		
