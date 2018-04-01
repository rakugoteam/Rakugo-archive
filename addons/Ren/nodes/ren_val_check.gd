extends Button

export(String) var val_name = "" 

export(bool) var default = false setget set_default, get_default


func set_default(val):
	default = val
	pressed = default

func get_default():
	return default

func _ready():
	if val_name in Ren.values:
		default = Ren.get_value(val_name)
	
	else:
		Ren.define(val_name, default)
	
	connect("toggled", self, "on_toggled", [], CONNECT_PERSIST)
	Ren.connect("val_changed", self, "on_val_changed", [], CONNECT_PERSIST)

func on_val_changed(valn):
	if val_name != valn:
		return

	pressed = Ren.get_value(val_name)

func on_toggled(val):
	Ren.define(val_name, val)
