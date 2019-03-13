extends RakugoVar
"""
Object used to handling Rakugo's booleans
"""
class_name RakugoBool

signal value_changed(var_name, new_value)

func _init(var_name:String, var_value:bool
	).(var_name, var_value, Rakugo.Type.BOOL):
	pass

func _set_value(var_value:bool) -> void:
	._set_value(var_value)

func _get_value() -> bool:
	return _value

func on() -> void:
	value = true

func off() -> void:
	value = false

func switch() -> void:
	value != value

func is_on() -> bool:
	return value == true

func is_off() -> bool:
	return  value == false



