extends VBoxContainer

func _ready():
	$Slider.connect("value_changed", self, "on_change_value")
	$HBox/CheckButton.connect("toggled", self, "on_toggle")
	connect("visibility_changed", self, "on_visibility_changed")


func on_change_value(value):
	var new_value = abs(value)
	Ren.set_var("text_speed", new_value)
	$HBox/CheckButton.pressed = value != 0

func on_toggle(value):
	if value:
		on_change_value(0)
	else:
		on_change_value(-0.01)

func on_visibility_changed():
	if visible == false:
		return
	
	on_change_value(Ren.get_value("text_speed"))