extends "ren_var_range.gd"


func _ready():
	._ready()
	connect("value_changed", self, "on_slider_val_changed")

func on_var_changed(varn):
	if var_name != varn:
		return
	
	value = Ren.get_value(var_name)

func on_slider_val_changed(value):
	Ren.define(var_name, value)

	
