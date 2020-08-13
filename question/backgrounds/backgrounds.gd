tool
extends RakugoNode2D

var current_bg : Node2D
var bgs := [
	"lecturehall",
	"club",
	"meadow",
	"uni"
	]

func hide_all(n:Node):
	for ch in n.get_children():
			if ch.has_method("hide"):
				ch.hide()


func _on_substate(substate):	
	if substate in bgs:
		hide_all(self)
		
		current_bg = get_node(substate)
		current_bg.show()
		show()
