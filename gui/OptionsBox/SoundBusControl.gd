extends VBoxContainer

export(String) var label := "Volume"
export(String) var bus_name := "Master"
var bus_id := 0
var mute := false
var volume := 0

func _ready() -> void:
	bus_id = AudioServer.get_bus_index(bus_name)

	$VBox/Label.text = label
	
	var _mute := AudioServer.is_bus_mute(bus_id)
	$VBox/CheckButton.pressed = !_mute
	
	$VBox/CheckButton.connect(
		"toggled", self,
		"set_bus_on", [bus_id]
	)
	
	$Bar.connect(
		"value_changed", self,
		"set_bus_volume", [bus_id]
	)

	connect("visibility_changed", self, "_on_visibility_changed")


func _on_visibility_changed() -> void:
	if not visible:
		return
	
	$Bar.value = AudioServer.get_bus_volume_db(bus_id)


func set_bus_volume(value: int, bus_id: int) -> void:
	AudioServer.set_bus_volume_db(bus_id, value)
	volume = value


func set_bus_on(bus_id: int, value: bool) -> void:
	AudioServer.set_bus_mute(bus_id, !value)
	mute = value
