extends VBoxContainer

func _ready():
	$Slider.connect("value_changed", self, "on_change_value")
	connect("visibility_changed", self, "on_visibility_changed")

func on_change_value(value):
	var new_value = abs(value)
	Ren.set_var("auto_speed", new_value)

func on_visibility_changed():
	if visible == false:
		return
	
	on_change_value(Ren.get_value("auto_speed"))