extends RenVar
class_name RenRange

var min_value = 0
var max_value = 100

func _init():
	_type = 8 # Ren.Type.RANGE

func _set_value(var_value):
	if var_value > max_value:
		var_value = max_value
	elif var_value < min_value:
		var_value = min_value
	._set_value(var_value)
