extends LineEdit

export(String) var val_name = ""

export(String) var default = "" setget set_default, get_default

var type = "str"

func set_default(value):
	default = value
	placeholder_text = str(default)

func get_default():
	return default

func _ready():
	var s = ""
	if val_name in Ren.values:
		s = Ren.get_value(val_name)
		default = str(s)
	
	type = Ren.get_type(s)
	
	connect("text_entered", self, "_on_entered")
	Ren.connect("val_changed", self, "on_val_changed")

func on_val_changed(valn):
	if val_name != valn:
		return
	
	text = ""
	placeholder_text = str(Ren.get_value(val_name))

func _on_entered(text):
	if text.empty():
		Ren.define_from_str(val_name, default, type)
	
	else:
		Ren.define_from_str(val_name, text, type)
	
