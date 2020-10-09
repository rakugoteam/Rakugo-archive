extends Node

const default_window_size := Vector2(1024, 600)

var _prev_window_size: Vector2
var _prev_window_fullscreen: bool

var temp_window_size: Vector2
var temp_vsync_enabled: bool
var temp_window_fullscreen: bool

var window_size: Vector2 setget _set_window_size, _get_window_size
var window_fullscreen: bool setget _set_window_fullscreen, _get_window_fullscreen

var saves_scroll := 0
var saves_skip_naming := false
var saves_page_names := {}

var audio_buses := {}


signal window_size_changed(prev, now)
signal window_fullscreen_changed(value)

func _ready() -> void:
	temp_window_fullscreen = OS.window_fullscreen
	temp_window_size = OS.window_size
	temp_vsync_enabled = OS.vsync_enabled

	load_conf()

	_prev_window_size = OS.window_size
	_prev_window_fullscreen = OS.window_fullscreen

func _set_window_size(value: Vector2) -> void:
	_prev_window_size = OS.window_size
	OS.window_size = value
	emit_signal("window_size_changed", _prev_window_size, value)

func _get_window_size() -> Vector2:
	return OS.window_size

func _set_window_fullscreen(value: bool) -> void:
	_prev_window_fullscreen = OS.window_fullscreen
	OS.window_fullscreen = value
	emit_signal("window_fullscreen_changed", value)


func _get_window_fullscreen() -> bool:
	return OS.window_fullscreen

func _process(delta: float) -> void:
	if OS.window_size != _prev_window_size:
		emit_signal("window_size_changed", _prev_window_size, OS.window_size)

	if OS.window_fullscreen != _prev_window_fullscreen:
		emit_signal("window_fullscreen_changed", OS.window_fullscreen)

	_prev_window_size = OS.window_size
	_prev_window_fullscreen = OS.window_fullscreen


func conf_set_rakugo_value(config: ConfigFile, value_name, def_rakugo_value):
	#config.set_value("rakugo", value_name, Rakugo.get_value(def_rakugo_value))#TODO fix that
	pass


func save_conf() -> void:
	var config = ConfigFile.new()
	config.set_value("saves", "scroll", saves_scroll)
	config.set_value("saves", "skip_naming", saves_skip_naming)
	config.set_value("saves", "page_names", saves_page_names)
	config.set_value("display", "width", _get_window_size().x)
	config.set_value("display", "height", _get_window_size().y)
	config.set_value("display", "fullscreen", _get_window_fullscreen())
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
		audio_buses[bus_name] = {"mute":mute, "volume": volume}

	conf_set_rakugo_value(config, "Typing_Text", "typing_text")
	conf_set_rakugo_value(config, "Text_Time", "text_time")
	conf_set_rakugo_value(config, "Auto_Forward_Time", "auto_time")
	conf_set_rakugo_value(config, "Notify_Time", "notify_time")

	# do nothing for now
	conf_set_rakugo_value(config, "Skip_All_Text", "skip_all_text")
	conf_set_rakugo_value(config, "Skip_After_Choices", "skip_after_choices")



	# Save the changes by overwriting the previous file
	config.save("user://settings.cfg")


func load_conf() -> void:
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")

	if err != OK: # if not, something went wrong with the file loading
		return

	# Look for the display/width pair, and default to 1024 if missing
	saves_scroll = config.get_value("saves", "scroll", 0)
	saves_skip_naming = config.get_value("saves", "skip_naming", false)
	saves_page_names = config.get_value("saves", "page_names", {})
	temp_window_size.x = config.get_value("display", "width", default_window_size.x)
	temp_window_size.y = config.get_value("display", "height", default_window_size.y)
	temp_window_fullscreen = config.get_value("display", "fullscreen", false)
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
		audio_buses[bus_name] = {"mute":mute, "volume":volume}
		AudioServer.set_bus_mute(bus_id, mute)
		AudioServer.set_bus_volume_db(bus_id, volume)

	var typing_text = config.get_value("rakugo", "Typing_Text", Rakugo._typing_text)
	var text_time = config.get_value("rakugo", "Text_Time", Rakugo._text_time)
	var auto_time = config.get_value("rakugo", "Auto_Forward_Time", Rakugo._auto_time)
	var notify_time = config.get_value("rakugo", "Notify_Time", Rakugo._notify_time)

	# do nothing for now
	var skip_all_text = config.get_value("rakugo", "Skip_All_Text", Rakugo._skip_all_text)
	var skip_after_choices = config.get_value("rakugo", "Skip_After_Choices", Rakugo._skip_after_choices)

	#Rakugo.set_var("typing_text", typing_text)
	#Rakugo.set_var("text_time", text_time)
	#Rakugo.set_var("auto_time", auto_time)
	#Rakugo.set_var("notify_time", notify_time)

	# do nothing for now
	#Rakugo.set_var("skip_all_text", skip_all_text)
	#Rakugo.set_var("skip_after_choices", skip_after_choices)



func apply() -> void:
	_set_window_fullscreen(temp_window_fullscreen)
	OS.vsync_enabled = temp_vsync_enabled





func load_property_list():
	var config = ConfigFile.new()
	property_list = {}
	var err = config.load("user://settings.cfg")#TODO replace it with a setting set path
	if err == OK:
		for section in config.get_sections():
			for key in config.get_section_keys(section):
				var property_key = "rakugo/%s/%s" % [section, key]
				property_list[property_key] = config.get_value(section, key)


func save_property_list():
	var config = ConfigFile.new()
	var key = []
	for property in property_list.keys():
		key = property.split("/", false, 2)
		config.set_value(key[1], key[2], property_list[property])
	config.save("user://settings.cfg")#TODO replace it with a setting set path


func get(property, default=null):
	print("Prout ",property, "  ", ProjectSettings.has_setting(property), "  ",ProjectSettings.property_get_revert(property))
	if property in property_list:
		return property_list[property]
	if ProjectSettings.has_setting(property):
		return ProjectSettings.get_setting(property)
	if property in default_property_list:
		return default_property_list[property][0]
	if default:
		property_list[property] = default
	return default


func set(property, value, save_changes=true):
	property_list[property] = value
	if save_changes:
		var config = ConfigFile.new()
		var key = property.split("/", false, 2)
		config.set_value(key[1], key[2], property_list[property])
		config.save("user://settings.cfg")#TODO replace it with a setting set path


var property_list:Dictionary = {}

var default_property_list:Dictionary = SettingsList.new().default_property_list
