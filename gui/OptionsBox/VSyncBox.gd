extends HBoxContainer

func _ready() -> void:
	connect("visibility_changed", self, "_on_visibility_changed")
	$CheckButton.connect("toggled", self, "_on_toggle")


func _on_toggle(value: bool) -> void:
	settings.temp_vsync_enabled = value


func _on_visibility_changed() -> void:
	$CheckButton.pressed = OS.vsync_enabled
	settings.temp_vsync_enabled = OS.vsync_enabled
	settings.apply()
