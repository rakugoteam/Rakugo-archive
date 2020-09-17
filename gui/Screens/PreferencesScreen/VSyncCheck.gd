extends CheckButton

func _on_toggle(value: bool) -> void:
	settings.temp_vsync_enabled = value
	settings.apply()

func _on_visibility_changed() -> void:
	pressed = OS.vsync_enabled
