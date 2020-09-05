extends Button

export var nav_action:String = ""

signal nav_button_pressed(nav_action)

func _on_pressed():
	emit_signal("nav_button_pressed", nav_action)
