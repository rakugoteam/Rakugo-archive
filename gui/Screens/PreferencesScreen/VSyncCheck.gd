extends CheckButton

func _on_toggle(value: bool) -> void:
	#settings.temp_vsync_enabled = value#TODO sort that out again
	#settings.apply()
	pass

func _on_visibility_changed() -> void:
	pressed = OS.vsync_enabled
