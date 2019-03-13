extends Object
# implements RakugoVar
"""
This object used to handling Rakugo's
 variables that are dictionaries
"""
class_name RakugoDict

var type : int setget , _get_type
var _type : int = 12 # Rakugo.Type.Dict
var value : Dictionary setget _set_value, _get_value
var _value : = {}
var v : Dictionary setget _set_value, _get_value
var name : String setget , _get_name
var _name : = ""

signal value_changed(var_name, new_value)
signal key_value_changed(var_name, key, new_value)

func _init(var_name:String, var_value:Dictionary):
	_name = var_name
	_value = var_value

func _get_type() -> int:
	return _type

func _set_value(dict:Dictionary) -> void:
	
	emit_signal("value_changed", _name, self)

func _get_value() -> Dictionary:
	return _value

func _get_name() -> String:
	return _name

func set_key_value(key, key_value) -> void: 
	value[key] = key_value
	emit_signal("key_value_changed", name, key, key_value)

func get_key_value(key):	
	return value.get(key)

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
