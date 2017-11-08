## This is example of script using Ren Framework ##

## version: 0.2.0 ##
## License MIT ##

extends Node2D

onready var ren = get_node("/root/Window")

func _ready():
	ren.character("rench", {
							"name": "Ren-Kun",
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
	
	ren.menu({
				"how":
					"rench",
				"what":
					"What want to do?"
			})
	
	ren.choice({"what": "Play Visual Novel example"})
	ren.say({
				"how":
					"rench",
				"what":
					"Visual Novel example is not ready yet"
			})
	ren.end()

	# ren.choice({"what": "Play Click'n'Point Adventure example"})
	# ren.say({
	# 			"how":
	# 				"rench",
	# 			"what":
	# 				"Click'n'Point Adventure example is not ready yet"
	# 		})
	# ren.end()

	# ren.choice({"what": "Play RPG example"})
	# ren.say({
	# 			"how":
	# 				"rench",
	# 			"what":
	# 				"RPG example is not ready yet"
	# 		})
	# ren.end()

	ren.choice({"what": "Ask some questions about Ren"})
	ren.say({
				"how":
					"rench",
				"what":
					"Docs are not ready yet"
			})
	ren.end()
	ren.end() # end of menu
	
	ren.say({
				"how":
					"rench",
				"what":
					"Its all for now"
			})
	
	ren.start()
