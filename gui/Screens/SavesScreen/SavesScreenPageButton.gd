extends Button

signal page_button_pressed(action)

func _ready():
	connect("pressed", self, "_on_pressed")

func _on_pressed():
	emit_signal("page_button_pressed", self.text)
