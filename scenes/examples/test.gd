## This is example of script using Ren Framework ##
## version: 0.5.0 ##
## License MIT ##

extends Node2D

onready var ren = get_node("/root/Window")

func _ready():
	ren.character("rench", {
							"name": "Ren",
							"avatar": "res://scenes/examples/RenAvatar.tscn"
							})
	
	ren.node_link($logo)
	
	ren.define("player_name")
	
	# ren.define("is_working", false)
	# ren.define("is_elif", true)
	# var first_case = ren.if_statement("is_working")
	# ren.say({"what":"if_statement work!"}, first_case)
	# var first_case_elif = ren.elif_statement("is_elif", first_case)
	# ren.say({"what":"elif_statement work!"}, first_case_elif)
	# var first_case_else = ren.else_statement(first_case)
	# ren.say({"what":"else_statement work!"}, first_case_else)

	# ren.gd("print('gd_statemnet works!')")

	# ren.gd_block(
	# """
	# print('godot_statemnet works!')
	# print('godot_statemnet works!')
	# """
	# )

	# ren.define("test_list", [1,3,7])
	# ren.say({"what":"test list 2 list elment is [test_list[2]]"})
	
	ren.show("logo",{"at":["center"]})
	ren.input({
				"how": 
					"rench",
				"what":
					"Hi! I'm Ren. What is your name?",
				"input_value":
						"player_name",
				"value":
					"Developer"
				})
				
	ren.say({
				"how": 
					"rench",
				"what":
					"Welcome [player_name] in Ren Framework Version [version]",
				"speed":
					0.1
				})
	ren.hide("logo")
	

	var menu01 = ren.menu({
				"how":
					"rench",
				"what":
					"What want to do?"
				})

	var choice_vn = ren.choice({"what": "Play Visual Novel example"}, menu01)
	ren.say({
				"how":
					"rench",
				"what":
					"Visual Novel example is not ready yet"
			}, choice_vn)
	
				
	var choice_adv = ren.choice({"what": "Play Click'n'Point Adventure example"}, menu01)
	ren.say({
			"how":
				"rench",
			"what":
				"Click'n'Point Adventure example is not ready yet"
			}, choice_adv)
	

	var choice_rpg = ren.choice({"what": "Play RPG example"}, menu01)
	ren.say({
				"how":
					"rench",
				"what":
					"RPG example is not ready yet"
			}, choice_rpg)
	

	var choice_aq = ren.choice({"what": "Ask some questions about Ren"}, menu01)
	ren.say({
				"how":
					"rench",
				"what":
					"Docs are not ready yet"
			}, choice_aq)
	
	
	ren.start()
