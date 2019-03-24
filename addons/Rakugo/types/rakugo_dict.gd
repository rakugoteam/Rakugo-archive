extends RakugoVar
"""
This object used to handling Rakugo's
 variables that are dictionaries
"""
class_name RakugoDict

signal value_changed(var_name, new_value)
signal key_value_changed(var_name, key, new_value)

func _init(var_name:String, var_value:Dictionary
	).(var_name, var_value, Rakugo.Type.DICT) -> void:
	pass

func _set_value(dict:Dictionary) -> void:
	._set_value(dict)

func _get_value() -> Dictionary:
	return _value

func _get(p_property):
	if _value.has(p_property):
		return _value[p_property]

func _set(p_property, p_value):
	if _value.has(p_property):
		_value[p_property] = p_value
		emit_signal("key_value_changed", name, p_property, p_value)

func _get_property_list():
	var ret := []
	for a_key in _value:
		ret.append({
			"name": a_key,
			"type": typeof(_value[a_key])
		})
	return ret

func clear():
	value.clear()
	
func empty():
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

func save_to(dict : Dictionary) -> void:
	var save := {
		"value": value,
		"type" : type
	}
	dict[name] = save
	

func load(dict : Dictionary) -> void:
	pass