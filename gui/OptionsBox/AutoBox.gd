extends VBoxContainer

func _ready() -> void:
	$Slider.connect("value_changed", self, "on_change_value")


func on_change_value(value: float) -> void:
	var new_value = abs(1 - value / 100) * 10
	
	if new_value <= 0:
		new_value = 0.1
	
	Rakugo.set_var("auto_time", new_value)
