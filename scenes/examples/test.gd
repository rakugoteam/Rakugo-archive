## This is example of script using Ren Framework ##

## version: 0.2.0 ##
## License MIT ##

extends Node2D

onready var ren = get_node("/root/Window")

func _ready():
	ren.character("rench", {
							"name": "Ren",
							"avatar": "res://scenes/examples/RenAvatar.tscn"
							})
	
	ren.define("player_name")
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
					"Welcome [player_name] in Ren Framework Version 0.2.0"
				})
	

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
	

	ren.say({
				"how":
					"rench",
				"what":
					"Its all for now"
			})

	ren.start()
