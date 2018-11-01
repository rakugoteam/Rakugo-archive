extends Object

## This base object used to handling Ren's variables

var type setget , _get_type
var _type = 0 # Ren.Type.Var
var value setget _set_value, _get_value
var _value = null 
var v = null setget _set_value, _get_value

signal value_changed(new_value)

func _get_type():
	return _type

func _set_value(var_value):
	_value = var_value
	emit_signal("value_changed", var_value)

func _get_value():
	return _value



