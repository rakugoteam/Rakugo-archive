extends RakugoVar
class_name RakugoRangedVar

var min_value : float setget _set_min_value, _get_min_value
var _min_value : float = 0
var max_value : float setget _set_max_value, _get_max_value
var _max_value : float = 100

signal min_value_changed(var_id, new_min_value)
signal max_value_changed(var_id, new_max_value)

func _init(var_id:String, var_value:float, min_value:float, max_value:float
	).(var_id, var_value, Rakugo.Type.RANGED) -> void:
	_max_value = max_value
	_min_value = min_value

func _set_value(var_value : float) -> void:
	if var_value > max_value:
		var_value = max_value

	elif var_value < min_value:
		var_value = min_value

	._set_value(var_value)

func _set_min_value(new_min_value : float) -> void:
	_min_value = new_min_value
	emit_signal("min_value_changed", _id, new_min_value)

func _get_min_value() -> float:
	return _min_value

func _set_max_value(new_max_value : float) -> void:
	_max_value = new_max_value
	emit_signal("max_value_changed", _id, new_max_value)

func _get_max_value() -> float:
	return _max_value
