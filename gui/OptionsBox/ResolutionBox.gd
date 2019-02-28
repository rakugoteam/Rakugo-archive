extends CollapsedList

func _ready() -> void:
	settings.connect("window_size_changed", self, "_on_window_size_changed")
	## taken from https://freegamedev.net/wiki/Screen_Resolutions
	options_list = [
		Vector2(640, 480),
		Vector2(800, 480),
		Vector2(1024, 600),
		Vector2(1024, 768),
		Vector2(1200, 900),
		Vector2(1280, 720),
		Vector2(1280, 1024),
		Vector2(1366, 768),
		Vector2(1440, 900),
		Vector2(1680, 1050),
		Vector2(1600, 1200),
		Vector2(1920, 1080),
		Vector2(2560, 1440),
		Vector2(2560, 1600)
	]
	
	var max_res_id = options_list.find(OS.get_screen_size())
	if max_res_id != -1:
		options_list.resize(max_res_id)

func _process(delta: float) -> void:
	update_label(OS.window_size, false)
	
func _on_window_size_changed(prev, now):
	update_label(now, false)

func update_label(size : Vector2 = options_list[current_choice_id], apply : bool = true) -> void:
	label.text = str(size.x) + "x" + str(size.y)
	
	if not (size in options_list):
		options_list.append(size)
	
	if not apply:
		return
	
	settings.temp_window_size = size
	
	if size == OS.get_screen_size():
		settings.window_fullscreen = true
		settings.window_maximized = false
	
	else:
		if settings.window_fullscreen:
			settings.window_fullscreen = false
		
		if settings.window_maximized:
			settings.window_maximized = false
			
	settings.apply(true)
