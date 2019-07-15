extends LineEdit
class_name RakugoVarEdit

export var var_name := "some_var"

export var default = "" setget set_default, get_default

var type := "str"

func set_default(value) -> void:
	default = value
	placeholder_text = str(default)


func get_default():
	return default


func _ready() -> void:
	var s = ""
	if var_name in Rakugo.variables:
		s = Rakugo.get_value(var_name)
		default = str(s)
	
	var var_to_change = Rakugo.get_var(var_name)
	
	type = Rakugo.get_def_type(s)
	
	connect("text_entered", self, "_on_entered")
	var_to_change.connect("value_changed", self, "on_value_changed")


func on_value_changed(vname: String, new_value) -> void:
	if vname != var_name:
		return

	text = ""
	placeholder_text = str(new_value)


func _on_entered(text: String) -> void:
	if text.empty():
		Rakugo.define_from_str(var_name, default, type)
	
	else:
		Rakugo.define_from_str(var_name, text, type)
