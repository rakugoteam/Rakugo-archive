extends Object
"""
Base object used to handling Rakugo's variables
"""
class_name RakugoVar

var type : int setget , _get_type
var _type : = 0 # Rakugo.Type.Var
var value setget _set_value, _get_value
var _value = null
var v setget _set_value, _get_value
var name : String setget , _get_name
var _name : = ""

signal value_changed(var_name, new_value)

func _init(var_name:String, var_value, var_type: = 0):
	_name = var_name
	_value = var_value
	_type = var_type

func _get_type() -> int:
	return _type

func _set_value(var_value) -> void:
	_value = var_value
	emit_signal("value_changed", _name, _value)

func _get_value():
	return _value

func _get_name() -> String:
	return _name



