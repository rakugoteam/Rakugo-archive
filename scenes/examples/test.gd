## This is example of script using Ren Framework ##

## version: 0.1.0 ##
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
				"temp":
					"Developer",
				"value":
						"player_name"
				})
				
	ren.say({
				"how": 
					"rench",
				"what":
					"Welcome [player_name] in Ren Framework Version 0.1.0"
				})
	
	ren.statements[0].use()
