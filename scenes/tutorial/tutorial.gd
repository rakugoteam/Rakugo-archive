## This is Ren'GD example scene script##
## Ren'GD is Ren'Py for Godot ##
## version: 0.7 ##
## License MIT ##


extends "res://scripts/RenGD/ren_short.gd"

var another_time = false

func _ready():

	# if not another_time:
	# 	another_time = true
	# 	first()

	first()
	
	start()
	## This must be at end of code.
	## this start ren "magic" ;)
	

func first():
	var tscn_path = "res://scenes/tutorial/tutorial.tscn"
	label("tutorial", tscn_path, "first")
	## It add this scene func to know labels
	## It allows later to easy swich between scenes and thier labels
	## It allows also to reuse scene with different labels
	## using: jump(label_name, [func_args_if_any])
	## You must labeled func before 'jumping' to it!
	
	## set_label_current_label("tutorial_2d_api")
	## beacose it is first label in game I must write above method to get next things work

	define("guest") ## it add 'guest' var to 'keywords' dict that is global and will be saved
	input("guest", "What is your name?", "Godot Developer")
	## input will set guest var as what you type after pressing enter key
	## It use renpy markup format iI discribed it more under first use of say
	
	var jer = Character("Jeremi360", "#25c33e")
	define("jer", jer)
	## This is how you declare a new Character

	node("jer", get_node("TestAvatar/Normal"))
	auto_subnodes("jer", get_node("TestAvatar"), "Normal")
	ren_show("jer Smile")
	say("jer", "Hi this is how i look.")
	say("jer", "And now I will hide")
	ren_hide("jer Smile")

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
		"Label",
		"Node"
	]

	menu(topics, "What you want to know?", self, "topic_choice")

	define("ex_path", tscn_path)
	say("jer", 
			"""It's end for now to see how it is done see:
			{tab}- [ex_path].gd
			{tab}- [ex_path].tscn""")
	
	say("jer", "Goodbye, [guest].")
	

func topic_choice(choice):
	before_menu()

	#if choice == 0: #Basic

	if choice == 1: #Say
		say("jer", "Say statment/func is make character speaks.")
		say("jer", """The GDScript way to call it is:
								{code}say('how','what'){/code}""")
		say("jer", """The Ren'GD Script way to call it is:
								{code}'how' 'what'{/code} or {code}charcter_var 'what'{/code}""")
	
	#if choice == 2: #Character

	elif choice == 3: #Input
		say("jer", "Input statment/func is way to provide text input file for player.")
		say("jer", """The GDScript way to call it is:
								{code}input('var','what','temp'){/code}""")
		say("jer", """The Ren'GD Script way to call it is:
								{code}g: input('var','what','temp'){/code}""")
	
	# #elif choice == 4: #Menu

	# #elif choice == 5: #Label

	# #elif choice == 6: # Node
		
	
	else:
		say('', "To be done :(.")
	

	after_menu()
	
		
