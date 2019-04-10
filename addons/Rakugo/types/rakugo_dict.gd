extends RakugoVar
class_name RakugoDict

func _init(var_id:String, var_value:Dictionary
	).(var_id, var_value, Rakugo.Type.DICT) -> void:
	pass

func _set_value(dict:Dictionary) -> void:
	._set_value(dict)

func _get_value() -> Dictionary:
	return _value

func clear() -> void:
	value.clear()
	
func empty() -> void:
	value.empty()
	
func erase(key) -> bool:
	return value.erase(key)
	
func has(key) -> bool:
	return value.has(key)
	
func has_all(keys:Array) -> bool:
	return value.has_all(keys)
	
func keys() -> Array:
	return value.keys()
	
func size() -> int:
	return value.size()
	
func values() -> Array:
	return value.values()