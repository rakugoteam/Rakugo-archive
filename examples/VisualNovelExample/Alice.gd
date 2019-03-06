extends RakugoNode2D

var scale_x = 1

func _ready():
	scale_x = scale.x

func on_state(state):
	if "doubt" in state:
		$AnimatedSprite.frame = 1
		
	elif "emabras" in state:
		$AnimatedSprite.frame = 2
	
	elif "happy" in state:
		$AnimatedSprite.frame = 3
	
	else:
		$AnimatedSprite.frame = 0
	
	if "right" in state:
		scale.x = scale_x
		
	elif "left" in state:
		scale.x = -scale_x
	
