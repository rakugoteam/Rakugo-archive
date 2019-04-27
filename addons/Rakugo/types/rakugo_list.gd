extends RakugoVar
class_name RakugoList

signal index_value_change(var_id, index, index_value)

func _init(var_id:String, var_value:Array
	).(var_id, var_value, Rakugo.Type.LIST):
	pass

func _set_value(var_value:Array) -> void:
	._set_value(var_value)

func _get_value() -> Array:
	return _value

func set_index_value(index:int, index_value) -> void:
	_value[index] = index_value
	emit_signal("index_value_change", id, index, index_value)

func get_index_value(index:int):
	return _value[index]

func add(value_to_add) -> void:
	_value.append(value_to_add)
	
func back():
	_value.back()

func bsearch(index_value, before:=true) -> int:
	return _value.bsearch(index_value, before)

func bsearch_custom(index_value, obj:Object, func_name:String, before:=true) -> int:
	return _value.bsearch_custom(index_value, obj, func_name, before)

func clear():
	_value.clear()

func count(value_to_count) -> int:
	return _value.count(value_to_count)

func empty() -> bool:
	return _value.empty()

func erase(value_to_erase) -> void:
	_value.erase(value_to_erase)

func find(what, from:=0) -> int:
	return _value.find(what, from)

func find_last(what) -> int:
	return _value.find_last(what)

func front():
	_value.front()

func has(value_to_check) -> bool:
	return _value.has(value_to_check)

func insert(position:int, value_to_insert) -> void:
	_value.insert(position, value_to_insert)

func invert() -> void:
	_value.invert()

func max_value():
	return _value.max()

func min_value():
	return _value.min()

func pop_back():
	return _value.pop_back()

func pop_front():
	return _value.pop_front()

func push_back(value_to_push) -> void:
	_value.push_back(value_to_push)

func push_front(value_to_push) -> void:
	_value.push_front(value_to_push)

func remove(position:int) -> void:
	_value.remove(position)

func resize(size:int) -> void:
	_value.resize(size)

func rfind(what, from:=-1) -> int:
	return _value.rfind(what, from)

func shuffle() -> void:
	_value.shuffle()

func size() -> int:
	return _value.size()

func sort() -> void:
	_value.sort()

func sort_custom(obj:Object, func_name:String) -> void:
	_value.sort_custom(obj, func_name)

func parse_text(text:String, open:String, close:String) -> String:
	text = .parse_text(text, open, close)
	
	for i in range(_value.size()):
		var sa = open + _id + "[" + str(i) + "]" + close
		
		if text.find(sa) == -1:
			continue # no variable in this string
	
		text = text.replace(sa, str(_value[i]))
	
	return text
	




