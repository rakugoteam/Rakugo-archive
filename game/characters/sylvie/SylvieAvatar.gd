extends RakugoAvatar

var current_wear : Node2D

func hide_all(n:Node):
	for ch in n.get_children():
			if ch.has_method("hide"):
				ch.hide()

func _on_substate(substate):	
	if substate  in ["blue", "green"]:
		hide_all($Node2D)
		
		current_wear = $Node2D.get_node(substate)
		current_wear.show()
	
	if substate in ["giggle",  "normal", "smile", "surprised"]:
		hide_all(current_wear)
		current_wear.get_node(substate).show()
	
	prints("shows", substate)
		