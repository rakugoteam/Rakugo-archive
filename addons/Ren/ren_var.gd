extends Object

var _name = "new_ren_var" setget , _get_name
var type = "var" setget , _get_type
var value = null setget _set_value, _get_value
var v = null setget _set_value, _get_value

func _get_name():
	return _name

func _get_type():
	return Ren.get_value_type(_name)

func _set_value(var_value):
	Ren.define(_name, var_value)

func _get_value():
	return Ren.get_value(_name)



