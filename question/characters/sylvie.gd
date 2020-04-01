tool
extends RakugoNode2D

var current_wear : Node2D
var clothes := [
	"blue",
	"green"
	]

var emotions := [
	"giggle", 
	"normal",
	"smile",
	"surprised"
	]

func _ready() -> void:
	hide_all(self)


func hide_all(n:Node):
	for ch in n.get_children():
		if ch.has_method("hide"):
			ch.hide()


func _on_substate(substate):
	if substate in clothes:
		hide_all(self)
		
		current_wear = get_node(substate)
		current_wear.show()
	
	if substate in emotions:
		hide_all(current_wear)
		current_wear.get_node(substate).show()
		
		
