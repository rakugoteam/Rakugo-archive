extends Object
class_name RakugoVar

var type : int setget , _get_type
var _type : = 0 # Rakugo.Type.Var
var value setget _set_value, _get_value
var _value = null
var id : String setget , _get_id
var _id := ""
var var_suffix : String setget , _get_var_suffix
var _suffix := ""

var save_included := true

signal value_changed(var_id, new_value)
signal key_value_changed(var_id, key, new_value)

func _init(var_id:String, var_value, var_type: = 0, var_suffix: = ""):
	_id = var_suffix + var_id
	_value = var_value
	_type = var_type
	_suffix = var_suffix

func _get_type() -> int:
	return _type

func _set_value(var_value) -> void:
	_value = var_value
	emit_signal("value_changed", _id, _value)

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

func save_to(dict:Dictionary) -> void:
	if !save_included:
		return

	var save := {
		"value": _value,
		"type" : _type
	}

	dict[_id] = save

	Rakugo.debug(["saveing", _id])

func load_from(dict:Dictionary) -> void :
	_value = dict

func to_string() -> String:
	return str(_value)

func parse_text(text:String, open:String, close:String) -> String:
	var s = open + _id + close
	return text.replace(s, to_string())

func _get_var_suffix() -> String:
	return _suffix
