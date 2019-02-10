extends Button
class_name RenVarCheckButton

export var var_name : = "some_var" 

export var default : = false setget set_default, get_default

var var_to_change : RenVar

func set_default(value : bool) -> void:
	default = value
	pressed = default

func get_default() -> bool:
	return default

func _ready() -> void:
	if var_name in Ren.variables:
		default = Ren.get_value(var_name)
		var_to_change = Ren.get_var(var_name)
	
	else:
		var_to_change = Ren.define(var_name, default)
	
	connect("toggled", self, "on_toggled")
	var_to_change.connect("value_changed", self, "on_value_changed")

func on_value_changed(new_value : bool) -> void:
	pressed = new_value

func on_toggled(value : bool) -> void:
	var_to_change.v = value
