extends Node

const default_window_size = Vector2(1024, 600)

var _prev_window_size
var _prev_window_minimized
var _prev_window_maximized
var _prev_window_fullscreen

var temp_window_size
var temp_vsync_enabled
var temp_window_type_id

var window_size setget _set_window_size, _get_window_size
var window_minimized setget _set_window_minimized, _get_window_minimized
var window_maximized setget _set_window_maximized, _get_window_maximized
var window_fullscreen setget _set_window_fullscreen, _get_window_fullscreen

signal window_size_changed(prev, now)
signal window_minimized_changed(value)
signal window_maximized_changed(value)
signal window_fullscreen_changed(value)

func _ready():
	temp_window_type_id = get_window_type_id()
	temp_window_size = OS.window_size
	temp_vsync_enabled = OS.vsync_enabled

	load_conf()

	_prev_window_size = OS.window_size
	_prev_window_minimized = OS.window_minimized
	_prev_window_maximized = OS.window_maximized
	_prev_window_fullscreen = OS.window_fullscreen

func get_window_type_id():
	var window_type_id = 0
	
	if OS.window_fullscreen:
		window_type_id = 1

	if OS.window_maximized:
		window_type_id = 2

	return window_type_id

func _set_window_size(value):
	_prev_window_size = OS.window_size
	OS.window_size = value
	emit_signal("window_size_changed", _prev_window_size, value)

func _get_window_size():
	return OS.window_size

func _set_window_minimized(value):
	_prev_window_minimized = OS.window_minimized
	OS.window_minimized = value
	emit_signal("window_minimized_changed", value)

func _get_window_minimized():
	return OS.window_minimized

func _set_window_maximized(value):
	_prev_window_maximized = OS.window_maximized
	OS.window_maximized = value
	emit_signal("window_maximized_changed", value)

func _get_window_maximized():
	return OS.window_maximized

func _set_window_fullscreen(value):
	_prev_window_fullscreen = OS.window_fullscreen
	OS.window_fullscreen = value
	emit_signal("window_fullscreen_changed", value)

func _get_window_fullscreen():
	return OS.window_fullscreen

func _process(delta):
	if OS.window_size != _prev_window_size:
		emit_signal("window_size_changed", _prev_window_size, OS.window_size)
	
	if OS.window_minimized != _prev_window_minimized:
		emit_signal("window_minimized_changed", OS.window_minimized)
	
	if OS.window_maximized != _prev_window_maximized:
		emit_signal("window_maximized_changed", OS.window_maximized)
	
	if OS.window_fullscreen != _prev_window_fullscreen:
		emit_signal("window_fullscreen_changed", OS.window_fullscreen)
	
	_prev_window_size = OS.window_size
	_prev_window_minimized = OS.window_minimized
	_prev_window_maximized = OS.window_maximized
	_prev_window_fullscreen = OS.window_fullscreen

func save_conf():
	var config = ConfigFile.new()
	config.set_value("display", "width", _get_window_size().x)
	config.set_value("display", "height", _get_window_size().y)
	config.set_value("display", "fullscreen", get_window_type_id())
	config.set_value("display", "vsync", OS.vsync_enabled)

	var audio_bus = [
		"Master",
		"BGM",
		"SFX",
		"Dialogs"
	]

	for bus_name in audio_bus:
		var bus_id = AudioServer.get_bus_index(bus_name)
		var mute = AudioServer.is_bus_mute(bus_id)
		var volume = AudioServer.get_bus_volume_db(bus_id)
		config.set_value("audio", bus_name + "_mute", mute)
		config.set_value("audio", bus_name + "_volume", volume)
	
	config.set_value("ren", "Text_Speed", Ren.get_value("text_speed"))
	config.set_value("ren", "Auto_Forward_Speed", Ren.get_value("auto_speed"))
	config.set_value("ren", "Notify_Time", Ren.get_value("notify_time"))
	
	## do nothing for now
	config.set_value("ren", "Skip_All_Text", Ren.get_value("skip_all_text"))
	config.set_value("ren", "Skip_After_Choices", Ren.get_value("skip_after_choices"))
	
	# Save the changes by overwriting the previous file
	config.save("user://settings.cfg")

func load_conf():
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	if err != OK: # if not, something went wrong with the file loading
		return
		
	# Look for the display/width pair, and default to 1024 if missing
	temp_window_size.x = config.get_value("display", "width", default_window_size.x)
	temp_window_size.y = config.get_value("display", "height", default_window_size.y)
	temp_window_type_id = config.get_value("display", "fullscreen", 0)
	temp_vsync_enabled = config.get_value("display", "vsync", true)
	
	apply()

	var audio_bus = [
		"Master",
		"BGM",
		"SFX",
		"Dialogs"
	]

	for bus_name in audio_bus:
		var bus_id = AudioServer.get_bus_index(bus_name)
		var mute = config.get_value("audio", bus_name + "_mute", false)
		var volume = config.get_value("audio", bus_name + "_volume", 0)

		AudioServer.set_bus_mute(bus_id, mute)
		AudioServer.set_bus_volume_db(bus_id, volume)
	
	var text_speed = config.get_value("ren", "Text_Speed", Ren._text_speed)
	var auto_speed = config.get_value("ren", "Auto_Forward_Speed", Ren._auto_speed)
	var notify_time = config.get_value("ren", "Notify_Time", Ren._notify_time)
	
	## do nothing for now
	var skip_all_text = config.get_value("ren", "Skip_All_Text", Ren._skip_all_text)
	var skip_after_choices = config.get_value("ren", "Skip_After_Choices", Ren._skip_after_choices)

	Ren.set_var("text_speed", text_speed)
	Ren.set_var("auto_speed", auto_speed)
	Ren.set_var("notify_time", notify_time)

	## do nothing for now
	Ren.set_var("skip_all_text", skip_all_text)
	Ren.set_var("skip_after_choices", skip_after_choices)

func set_window_options(fullscreen, maximized):
	_set_window_fullscreen(fullscreen)
	_set_window_maximized(maximized)

func apply():
	match temp_window_type_id:
		0: # Windowed
			set_window_options(false, false)
		1: # Fullscreen
			set_window_options(true, false)
		2: # Maximized
			set_window_options(false, true)
		
	_set_window_size(temp_window_size)
	OS.vsync_enabled = temp_vsync_enabled

