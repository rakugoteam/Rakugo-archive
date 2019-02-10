extends LineEdit
class_name RenVarEdit

export var var_name : = "some_var"

export var default : = "" setget set_default, get_default

var type : = "str"

func set_default(value) -> void:
	default = value
	placeholder_text = str(default)

func get_default():
	return default

func _ready() -> void:
	var s = ""
	if var_name in Ren.variables:
		s = Ren.get_value(var_name)
		default = str(s)
	
	var var_to_change = Ren.get_var(var_name)
	
	type = Ren.get_def_type(s)
	
	connect("text_entered", self, "_on_entered")
	var_to_change.connect("value_changed", self, "on_value_changed")

func on_value_changed(new_value : String) -> void:
	text = ""
	placeholder_text = str(new_value)

func _on_entered(text : String) -> void:
	if text.empty():
		Ren.define_from_str(var_name, default, type)
	
	else:
		Ren.define_from_str(var_name, text, type)
	
