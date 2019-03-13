extends Dictionary
# implements RakugoVar
"""
This object used to handling Rakugo's
 variables that are dictionaries
"""
class_name RakugoDict

var type : int setget , _get_type
var _type : int = 0 # Rakugo.Type.Var
var value setget _set_value, _get_value
var v = null setget _set_value, _get_value
var name : String setget , _get_name
var _name : = ""

signal value_changed(var_name, new_value)

func _init(var_name:String, var_value, var_type: = 0):
	_name = var_name
	_value = var_value
	_type = var_type

func _get_type() -> int:
	return _type

func _set_value(dict:Dictionary) -> void:
	
	emit_signal("value_changed", _name, self)

func _get_value() -> Dictionary:
	return _value

func _get_name() -> String:
	return _name