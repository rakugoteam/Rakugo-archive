extends CheckButton

func _ready() -> void:
	settings.connect("window_fullscreen_changed", self, "_on_window_fullscreen_changed")


func _on_toggle(value: bool) -> void:

	settings.temp_window_fullscreen = value
	settings.apply()


func _on_window_fullscreen_changed(value) -> void:
	pressed = value
