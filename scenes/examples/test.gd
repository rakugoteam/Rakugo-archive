extends Node2D

onready var ren = get_node("/root/Window")

func _ready():
	ren.say({
				"how": 
					"Player-Kun",
				"what":
					"Lorem impsum some tesutm"
				})
	
	ren.say({
				"how": 
					"Player-Kun",
				"what":
					"Lorem impsum some tesutm 2"
				})

	ren.statements[0].use()
