## This is example of script using Ren Framework ##
## version: 0.5.0 ##
## License MIT ##

extends Node2D

func _ready():
#	Ren.character("rench", {
#							"name": "Ren",
#							"avatar": "res://scenes/examples/RenAvatar.tscn"
#							})
#
#	Ren.node_link($logo)
	
	Ren.define("player_name")
	
	Ren.define("is_working", false)
	Ren.define("is_elif", true)
#	var first_case = Ren.if_statement("is_working")
#	Ren.say({"what":"if_statement work!"}, first_case)
#	var first_case_elif = Ren.elif_statement("is_elif", first_case)
#	Ren.say({"what":"elif_statement work!"}, first_case_elif)
#	var first_case_else = Ren.else_statement(first_case)
#	Ren.say({"what":"else_statement work!"}, first_case_else)

	if Ren.get_value("is_working"):
		Ren.say({"what":"normal 'if' work!"})
	
	elif Ren.get_value("is_elif"):
		Ren.say({"what":"normal 'elif' work!"})
	
	else:
		Ren.say({"what":"normal 'else' work!"})

	
#	Ren.gd("print('gd_statemnet works!')")
#
#	Ren.gd_block(
#	"""
#	print('godot_statemnet works!')
#	print('godot_statemnet works!')
#	"""
#	)

	Ren.define("test_list", [1,3,7])
	Ren.say({"what":"test list 2 list elment is [test_list[2]]"})
	print("normal print works")
	
	Ren.show("rench", [], {"at":["center"]})
	
	Ren.input({
				"who": 
					"rench",
				"what":
					"Hi! I'm Ren. What is your name?",
				"input_value":
						"player_name",
				"value":
					"Developer"
				})
				
	Ren.say({
			"who": 
				"rench",
			"what":
				"Welcome [player_name] in Ren Framework Version [version]",
			"speed":
				0.1
			})
	Ren.hide("rench")
	Ren.say({
			"who": 
				"rench",
			"what":
				"extra stamement to check skipping/auto",
			})

	var menu01 = Ren.menu({
				"who":
					"rench",
				"what":
					"What want to do?"
				})

	# var choice_vn = Ren.choice({"what": "Play Visual Novel example"}, menu01)
	menu01.add_choice({"what": "Play Visual Novel example"})
	menu01.add_choice({"what": "Play Click'n'Point Adventure example"})
	menu01.add_choice({"what": "Play RPG example"})
	menu01.add_choice({"what": "Ask some questions about Ren"})
	menu01.enter()
	
	if menu01.final_choice == 0: #VN
		Ren.say({
					"who":
						"rench",
					"what":
						"Visual Novel example is not ready yet"
				}) # , choice_vn)
	
				
	# var choice_adv = Ren.choice({"what": "Play Click'n'Point Adventure example"}, menu01)
	elif menu01.final_choice == 1: # Adv
		Ren.say({
				"who":
					"rench",
				"what":
					"Click'n'Point Adventure example is not ready yet"
		})# , choice_adv)
	

	# var choice_rpg = Ren.choice({"what": "Play RPG example"}, menu01)
	elif menu01.final_choice == 2: # RPG
		Ren.say({
					"who":
						"rench",
					"what":
						"RPG example is not ready yet"
		}) #, choice_rpg)
	

	# var choice_aq = Ren.choice({"what": "Ask some questions about Ren"}, menu01)
	elif menu01.final_choice == 3: # Docs
		Ren.say({
					"who":
						"rench",
					"what":
						"Docs are not ready yet"
		}) #, choice_aq)
	
	Ren.notifiy("You make your first choice!",3)
	
	Ren.say({
			"who": 
				"rench",
			"what":
				"This end of this example.",
			})

