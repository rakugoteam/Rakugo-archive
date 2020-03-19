extends Node2D

func _ready():
	Rakugo.connect("begin", Rakugo, "hide", ["Dialog"])
	pass

func _on_ParkBtn_pressed():
	print("park")
	pass 
