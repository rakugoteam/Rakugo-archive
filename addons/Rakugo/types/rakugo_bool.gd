extends RakugoVar
class_name RakugoBool

func _init(var_id: String, var_value: bool
	).(var_id, var_value, Rakugo.Type.BOOL):
	pass

func _set_value(var_value: bool) -> void:
	._set_value(var_value)

func _get_value() -> bool:
	return _value

func on() -> void:
	_value = true

func off() -> void:
	_value = false

func switch() -> void:
	_value = !_value

func is_on() -> bool:
	return _value

func is_off() -> bool:
	return !_value
