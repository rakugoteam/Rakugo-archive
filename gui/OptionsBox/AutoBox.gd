extends VBoxContainer

func _ready() -> void:
	$Slider.connect("value_changed",
		self, "on_change_value")
	connect("visibility_changed",
		self, "on_visblity_changed")


func on_change_value(value: float) -> void:
	var new_value = abs(value)
#	prints("auto_time", new_value)
	Rakugo.set_var("auto_time", new_value)


func on_visblity_changed() -> void:
	if visible:
		$Slider.value = -Rakugo.get_value("auto_time")
