extends VBoxContainer

export(String) var label : = "Volume"
export(String) var bus_name : = "Master"
var bus_id : = 0
var mute : = false
var volume : = 0

func _ready() -> void:
	bus_id = AudioServer.get_bus_index(bus_name)

	$VBox/Label.text = label
	
	if AudioServer.is_bus_mute(bus_id):
		$VBox/OffButton.pressed = true
	else:
		$VBox/OnButton.pressed = true
	
	$VBox/OnButton.connect(
		"pressed", self,
		"set_bus_mute", [bus_id, false]
	)

	$VBox/OffButton.connect(
		"pressed", self,
		"set_bus_mute", [bus_id, true]
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

func set_bus_volume(value : float, bus_id : int) -> void:
	AudioServer.set_bus_volume_db(bus_id, value)
	volume = value

func set_bus_mute(bus_id : int, value : bool) -> void:
	AudioServer.set_bus_mute(bus_id, value)
	mute = value
