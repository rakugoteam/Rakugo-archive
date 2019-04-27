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
	_value.clear()
	
func empty() -> void:
	_value.empty()
	
func erase(key) -> bool:
	return _value.erase(key)
	
func has(key) -> bool:
	return _value.has(key)
	
func has_all(keys:Array) -> bool:
	return _value.has_all(keys)
	
func keys() -> Array:
	return _value.keys()
	
func size() -> int:
	return _value.size()
	
func values() -> Array:
	return _value.values()
	
func parse_text(text:String, open:String, close:String) -> String:
	text = .parse_text(text, open, close)
	
	for k in _value.keys():
		var sa = open +  _id + "." + k + close
		
		if text.find(sa) == -1:
			continue # no variable in this string
	
		text = text.replace(sa, _value[k])
	
	return text