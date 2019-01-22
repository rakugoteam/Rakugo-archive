extends RenVarRange
class_name RenVarSlider


func _ready():
	connect("value_changed", self, "on_slider_val_changed")

func on_slider_val_changed(value):
	Ren.define(var_name, value)

	
