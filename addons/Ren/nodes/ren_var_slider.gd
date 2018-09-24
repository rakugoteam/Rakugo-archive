extends "ren_var_range.gd"


func _ready():
	# ._ready()
	connect("value_changed", self, "on_slider_val_changed")

func on_value_changed(new_value):
	value = Ren.get_value(new_value)

func on_slider_val_changed(value):
	Ren.define(var_name, value)

	
