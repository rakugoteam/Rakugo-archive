extends RakugoVar
class_name NodeLink

func _init(var_id:String).(
	var_id, {"node_path":""}, Rakugo.Type.NODE) -> void:
	pass

func _set_value(dict:Dictionary) -> void:
	._set_value(dict)

func _get_value() -> Dictionary:
	return _value