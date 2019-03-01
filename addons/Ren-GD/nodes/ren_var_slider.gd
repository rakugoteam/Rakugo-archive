extends "ren_var_range.gd"
# extends RenVarRange
# class_name RenVarSlider - there is no need for that
# we don't want it be be seen in "add new Node" dialog,
# but to seen other Nodes that use it

func _ready() -> void:
	connect("value_changed", self, "on_slider_val_changed")

func on_slider_val_changed(value : float) -> void:
	Ren.define(var_name, value)
