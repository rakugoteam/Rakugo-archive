extends LineEdit

export(String) var val_name = "version" setget set_val_name, get_val_name 
var _val_name = ""

export(String) var default = "0.5.0" setget set_default, get_default
var _default = ""

func set_val_name(value):
	_val_name = value

func get_val_name():
	return _val_name

func set_default(value):
	_default = value
	placeholder_text = default

func get_default():
	return _default

func _ready():
	connect("text_entered", self, "_on_entered")

func _on_entered(text):
	if text.empty():
		Ren.define(val_name, default)
		return
	
	else:
		Ren.define(val_name, text)
	
