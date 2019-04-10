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
	value[index] = index_value
	emit_signal("index_value_change", id, index, index_value)

func get_index_value(index:int):
	return value[index]

func add(value_to_add) -> void:
	value.append(value_to_add)
	
func back():
	value.back()

func bsearch(index_value, before:=true) -> int:
	return value.bsearch(index_value, before)

func bsearch_custom(index_value, obj:Object, func_name:String, before:=true) -> int:
	return value.bsearch_custom(index_value, obj, func_name, before)

func clear():
	value.clear()

func count(value_to_count) -> int:
	return value.count(value_to_count)

func empty() -> bool:
	return value.empty()

func erase(value_to_erase) -> void:
	value.erase(value_to_erase)

func find(what, from:=0) -> int:
	return value.find(what, from)

func find_last(what) -> int:
	return value.find_last(what)

func front():
	value.front()

func has(value_to_check) -> bool:
	return value.has(value_to_check)

func insert(position:int, value_to_insert) -> void:
	value.insert(position, value_to_insert)

func invert() -> void:
	value.invert()

func max_value():
	return value.max()

func min_value():
	return value.min()

func pop_back():
	return value.pop_back()

func pop_front():
	return value.pop_front()

func push_back(value_to_push) -> void:
	value.push_back(value_to_push)

func push_front(value_to_push) -> void:
	value.push_front(value_to_push)

func remove(position:int) -> void:
	value.remove(position)

func resize(size:int) -> void:
	value.resize(size)

func rfind(what, from:=-1) -> int:
	return value.rfind(what, from)

func shuffle() -> void:
	value.shuffle()

func size() -> int:
	return value.size()

func sort() -> void:
	value.sort()

func sort_custom(obj:Object, func_name:String) -> void:
	value.sort_custom(obj, func_name)

	




