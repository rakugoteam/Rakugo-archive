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
var id : String setget , _get_id
var _id : = ""

var _inited := false
var save_included:=true

signal value_changed(var_id, new_value)
signal key_value_changed(var_id, key, new_value)

func _init(var_id:String, var_value, var_type: = 0):
	_id = var_id
	_value = var_value
	_type = var_type
	_inited = true

func _get_type() -> int:
	return _type

func _set_value(var_value) -> void:
	_value = var_value
	
	if _inited:
		emit_signal("value_changed", id, value)

func _get_value():
	return _value

func _get_id() -> String:
	return _id
	
func _get(p_property : String):
	if _value is Object: 
		if _value.has(p_property):
			return _value[p_property]

func _set(p_property:String, p_value) -> bool:
	if _value is Object:
		if _value.has(p_property):
			_value[p_property] = p_value
			emit_signal("key_value_changed", _id, p_property, p_value)
			return true
			
	return false

func _get_property_list() -> Array:
	var ret := []
	for a_key in _value:
		ret.append({
			"id": a_key,
			"type": typeof(_value[a_key])
		})
	return ret

func save_to(dict:Dictionary) -> void:
	if !save_included:
		return
		
	var save := {
		"id" : id,
		"value": value,
		"type" : type
	}
	
	dict[id] = save
	
func to_string() -> String:
	return str(value)


