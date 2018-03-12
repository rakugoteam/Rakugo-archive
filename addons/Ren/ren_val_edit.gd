extends LineEdit

export(String) var val_name = "version"

export(String) var default = "0.5.0" setget set_default, get_default

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
	Ren.connect("on_val_changed", self, "update")

func update(valn):
	if val_name == valn:
		text = ""
		placeholder_text = str(Ren.get_value(val_name))

func _on_entered(text):
	if text.empty():
		Ren.define_from_str(val_name, default, type)
	
	else:
		Ren.define_from_str(val_name, text, type)
	
