extends CheckButton

func _ready():
	get_tree().get_root().connect("size_changed", self, "_on_window_resized")


func _on_toggled(value):
	if value:
		OS.window_fullscreen = false
		OS.window_size.x = Settings.get("display/window/size/width", null, false, true)
		OS.window_size.y = Settings.get("display/window/size/height", null, false, true)


func _on_visibility_changed():
	if is_window_default_size():
				pressed = true

func _on_window_resized():
	pressed = is_window_default_size()

func is_window_default_size():
	if !OS.window_fullscreen:
		if OS.window_size.x == Settings.get("display/window/size/width", null, false, true):
			if OS.window_size.y == Settings.get("display/window/size/height", null, false, true):
				return true
	return false
