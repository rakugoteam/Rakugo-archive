extends Object
# impements RakugoVar
"""
Object used to handling Rakugo's booleans
"""
class_name RakugoBool

var type : int setget , _get_type
var _type : int = 12 # Rakugo.Type.Bool
var value setget _set_value, _get_value
var _value:bool
var v:bool setget _set_value, _get_value
var name : String setget , _get_name
var _name : = ""

signal value_changed(var_name, new_value)

func _init(var_name:String, var_value:bool):
	_name = var_name
	_value = var_value

func _get_type() -> int:
	return _type

func _set_value(var_value) -> void:
	_value = var_value
	emit_signal("value_changed", _name, _value)

func _get_value():
	return _value

func _get_name() -> String:
	return _name

func on():
	value = true

func off():
	value = false

func switch():
	value != value



