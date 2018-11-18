extends HBoxContainer

func _ready():
	connect("visibility_changed", self, "_on_visibility_changed")
	$OffButton.connect("pressed", self, "_on_toggle", [false])
	$OnButton.connect("pressed", self, "_on_toggle", [true])

func _on_toggle(value):
	settings.temp_vsync_enabled = value

func _on_visibility_changed():
	if OS.vsync_enabled:
		$OnButton.pressed = true
		settings.temp_vsync_enabled = true
	else:
		$OffButton.pressed = true
		settings.temp_vsync_enabled = false