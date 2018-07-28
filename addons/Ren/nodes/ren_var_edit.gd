extends LineEdit

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
	
	type = Ren.get_type(s)
	
	connect("text_entered", self, "_on_entered")
	Ren.connect("var_changed", self, "on_var_changed")

func on_var_changed(varn):
	if var_name != varn:
		return
	
	text = ""
	placeholder_text = str(Ren.get_value(var_name))

func _on_entered(text):
	if text.empty():
		Ren.define_from_str(var_name, default, type)
	
	else:
		Ren.define_from_str(var_name, text, type)
	
