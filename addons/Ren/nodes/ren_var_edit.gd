extends LineEdit
class_name RenVarEdit

export(String) var var_name = "some_var"

export(String) var default = "" setget set_default, get_default

var type = "str"

func set_default(value):
	default = value
	placeholder_text = str(default)

func get_default():
	return default

func _ready():
	var s = ""
	if var_name in Ren.variables:
		s = Ren.get_value(var_name)
		default = str(s)
	
	var var_to_change = Ren.get_var(var_name)
	
	type = Ren.get_def_type(s)
	
	connect("text_entered", self, "_on_entered")
	var_to_change.connect("value_changed", self, "on_value_changed")

func on_value_changed(new_value):
	text = ""
	placeholder_text = str(new_value)

func _on_entered(text):
	if text.empty():
		Ren.define_from_str(var_name, default, type)
	
	else:
		Ren.define_from_str(var_name, text, type)
	
