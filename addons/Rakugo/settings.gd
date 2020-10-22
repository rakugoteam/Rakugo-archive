extends Node

const default_window_size := Vector2(1024, 600)


var audio_buses := {}


signal window_size_changed(prev, now)
signal window_fullscreen_changed(value)

func _ready() -> void:
	load_property_list()



func save_conf() -> void:
	var config = ConfigFile.new()

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



func load_property_list():
	if Rakugo.persistent.get('settings'):
		property_list = Rakugo.persistent.get('settings')
	else:
		save_property_list()


func save_property_list():
	Rakugo.persistent.settings = property_list
	Rakugo.StoreManager.save_persistent_store()


func get(property, default=null, set_default=true, project_setting_only=false):
	if not project_setting_only and property in property_list:
		return property_list[property]
	if ProjectSettings.has_setting(property):
		return ProjectSettings.get_setting(property)
	if property in default_property_list:
		return default_property_list[property][0]
	if default and set_default:
		property_list[property] = default
	return default


func set(property, value, save_changes=true):
	property_list[property] = value
	if save_changes:
		Rakugo.StoreManager.save_persistent_store()


var property_list:Dictionary = {}

var default_property_list:Dictionary = SettingsList.new().default_property_list
