extends HBoxContainer

func _ready():
	connect("visibility_changed", self, "_on_visibility_changed")
	$CheckButton.connect("toggled", self, "_on_toggle")

func _on_toggle(value):
	settings.temp_vsync_enabled = value

func _on_visibility_changed():
	$CheckButton.pressed = OS.vsync_enabled
	settings.temp_vsync_enabled = OS.vsync_enabled
