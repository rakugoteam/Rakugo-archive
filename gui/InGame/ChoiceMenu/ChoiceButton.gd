extends Button

signal choice_button_pressed(button)

func _on_pressed():
	self.emit_signal("choice_button_pressed", self)
