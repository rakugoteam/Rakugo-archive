extends VBoxContainer

export(String) var label := "Volume"
export(String) var bus_name := "Master"
var bus_id := 0
var volume := 0.0
var mute := false


func _ready() -> void:
	bus_id = AudioServer.get_bus_index(bus_name)
	$VBox/Label.text = label
	mute = AudioServer.is_bus_mute(bus_id)
	$VBox/CheckButton.pressed = !mute
	$VBox/CheckButton.connect("toggled", self, "set_bus_on" )
	$Bar.connect("value_changed", self, "set_bus_volume")
	connect("visibility_changed", self, "_on_visibility_changed")


func _on_visibility_changed() -> void:
	if not visible:
		return
	
	volume = AudioServer.get_bus_volume_db(bus_id)
	$Bar.value = volume
	mute = AudioServer.is_bus_mute(bus_id)
	$VBox/CheckButton.pressed = !mute
#	prints("bus:", bus_name, bus_id,
#	AudioServer.get_bus_name(bus_id),
#	AudioServer.get_bus_index(bus_name),
#	"volume:", volume, "mute:", mute)


func set_bus_volume(value: int):
	AudioServer.set_bus_volume_db(bus_id, value)
	volume = value
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
