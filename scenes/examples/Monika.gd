extends "res://addons/Ren/nodes/character.gd"

var current_sprite

func show_side():
	if current_sprite != $Side:
		current_sprite.hide()
		current_sprite = $Side
		$Side.show()

func on_state(state):
	## normaly sprite is turned right
	if "right" in state:
		scale.x *= 1
		show_side()
	
	if "left" in state:
		scale.x *= -1
		show_side()
		
	if "front" in state:
		$Side.hide()
		$Front.show()
		current_sprite = $Front
	
	if "angry" in state:
		$AnimationPlayer.play(angry)
		
	



