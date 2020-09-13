extends Node2D

onready var viewport := $Panel/ViewportContainer/Viewport
onready var Screens := $Panel/Screens
onready var InGameGUI := $Panel/InGameGUI
onready var Loading := $Panel/Loading

func _ready():
	Rakugo.current_root_node = self
