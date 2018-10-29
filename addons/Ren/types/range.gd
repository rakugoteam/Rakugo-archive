extends "ren_var.gd"

var min = 0
var max = 100

func _init():
	_type = 8 # Ren.Type.RANGE

func _set_value(var_value):
	if var_value > max:
		var_value = max
	elif var_value < min:
		var_value = min
	._set_value(var_value)
