extends Button

func _ready():
	connect("pressed", self, "_on_apply")

func set_window_options(fullscreen, maximized):
	settings.window_fullscreen = fullscreen
	settings.window_maximized = maximized

func _on_apply():
	match settings.temp_window_type_id:
		0: # Windowed
			set_window_options(false, false)
		1: # Fullscreen
			set_window_options(true, false)
		2: # Maximized
			set_window_options(false, true)
		
	settings.window_size = settings.temp_window_size

	OS.vsync_enabled = settings.temp_vsync_enabled