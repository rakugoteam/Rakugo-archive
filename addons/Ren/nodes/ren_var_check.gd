extends Button
class_name RenVarCheckButton

export(String) var var_name = "some_var" 

export(bool) var default = false setget set_default, get_default

var var_to_change

func set_default(value):
	default = value
	pressed = default

func get_default():
	return default

func _ready():
	if var_name in Ren.variables:
		default = Ren.get_value(var_name)
		var_to_change = Ren.get_var(var_name)
	
	else:
		var_to_change = Ren.define(var_name, default)
	
	connect("toggled", self, "on_toggled")
	var_to_change.connect("value_changed", self, "on_value_changed")

func on_value_changed(new_value):
	pressed = new_value

func on_toggled(value):
	var_to_change.v = value
