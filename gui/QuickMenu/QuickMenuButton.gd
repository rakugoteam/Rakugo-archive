extends Button

export var quick_action:String = ''

signal quick_button_pressed(quick_action)

func _on_pressed():
	emit_signal("quick_button_pressed", quick_action)
