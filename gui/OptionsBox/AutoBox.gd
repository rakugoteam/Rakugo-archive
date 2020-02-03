extends VBoxContainer

func _ready() -> void:
	$Slider.connect("value_changed",
		self, "on_change_value")


func on_change_value(value: float) -> void:
	var new_value = abs(value)
	prints("auto_time", new_value)
	Rakugo.set_var("auto_time", new_value)
