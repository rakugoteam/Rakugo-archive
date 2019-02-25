"""
This base object used to handling Ren's variables
"""
extends Object
class_name RenVar

var type : int setget , _get_type
var _type : int = 0 # Ren.Type.Var
var value setget _set_value, _get_value
var _value = null
var v = null setget _set_value, _get_value

signal value_changed(new_value)

func _get_type() -> int:
	return _type

func _set_value(var_value) -> void:
	_value = var_value
	emit_signal("value_changed", var_value)

func _get_value():
	return _value



