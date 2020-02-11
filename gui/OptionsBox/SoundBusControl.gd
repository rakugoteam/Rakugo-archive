extends VBoxContainer

export var default_volume := -30
export(String) var label := "Volume"
export(String) var bus_name := "Master"
var bus_id := 0
var volume := 0.0
var mute := false


func _ready() -> void:
	bus_id = AudioServer.get_bus_index(bus_name)
	$VBox/Label.text = label
	
	mute = false
	
	if bus_name in settings.audio_buses:
		mute = bool(settings.audio_buses[bus_name].mute)
	
	AudioServer.set_bus_mute(bus_id, mute)
	$VBox/CheckButton.pressed = !mute
	$VBox/CheckButton.connect("toggled", self, "set_bus_on" )
	
	volume = default_volume
	
	if bus_name in settings.audio_buses:
		volume = float(settings.audio_buses[bus_name].volume)
	
	AudioServer.set_bus_volume_db(bus_id, volume)
	$Bar.value = volume
	
	$Bar.connect("value_changed", self, "set_bus_volume")
	connect("visibility_changed", self, "_on_visibility_changed")


func _on_visibility_changed() -> void:
	if not visible:
		return
	
	volume = AudioServer.get_bus_volume_db(bus_id)
	$Bar.value = volume
	mute = AudioServer.is_bus_mute(bus_id)
	$VBox/CheckButton.pressed = !mute
	settings.audio_buses[bus_name] = {"mute":mute, "volume":volume}
#	prints("bus:", bus_name, bus_id,
#	AudioServer.get_bus_name(bus_id),
#	AudioServer.get_bus_index(bus_name),
#	"volume:", volume, "mute:", mute)


func set_bus_volume(value: int):
	AudioServer.set_bus_volume_db(bus_id, value)
	volume = value
	settings.audio_buses[bus_name] = {"mute":mute, "volume":volume}
#	prints("bus:", bus_name, bus_id,
#	AudioServer.get_bus_name(bus_id),
#	AudioServer.get_bus_index(bus_name),
#	"volume:", volume)


func set_bus_on(value: bool) -> void:
	AudioServer.set_bus_mute(bus_id, !value)
	mute = value
#	prints("bus:", bus_name, bus_id,
#	AudioServer.get_bus_name(bus_id),
#	AudioServer.get_bus_index(bus_name),
#	"mute:", mute)
