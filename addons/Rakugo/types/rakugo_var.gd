extends Object
"""
Base object used to handling Rakugo's variables
"""
class_name RakugoVar

var type : int setget , _get_type
var _type : = 0 # Rakugo.Type.Var
var value setget _set_value, _get_value
var _value = null
var v setget _set_value, _get_value
var name : String setget , _get_name
var _name : = ""

signal value_changed(var_name, new_value)

func _init(var_name:String, var_value, var_type: = 0):
	_name = var_name
	_value = var_value
	_type = var_type

func _get_type() -> int:
	return _type

func _set_value(var_value) -> void:
	_value = var_value
	emit_signal("value_changed", _name, _value)

func _get_value():
	return _value

func _get_name() -> String:
	return _name
	
func _get(p_property : String):
	if _value is Object: 
		if _value.has(p_property):
			return _value[p_property]

func _set(p_property:String, p_value) -> bool:
	if _value is Object:
		if _value.has(p_property):
			_value[p_property] = p_value
			emit_signal("key_value_changed", name, p_property, p_value)
			return true
			
	return false

func _get_property_list() -> Array:
	var ret := []
	for a_key in _value:
		ret.append({
			"name": a_key,
			"type": typeof(_value[a_key])
		})
	return ret

func save_to(dict:Dictionary) -> void:
	var save := {
		"name" : name,
		"value": value,
		"type" : type
	}
	dict[name] = save

func load_to(data:Dictionary, dict:Dictionary) -> bool:
	if type == dict["type"]:
		_name = dict["name"]
		._set_value(dict["value"])
		dict[_name] = self
		return true
	
	return false


