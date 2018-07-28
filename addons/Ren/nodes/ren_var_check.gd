extends Button

export(String) var var_name = "some_var" 

export(bool) var default = false setget set_default, get_default


func set_default(value):
	default = value
	pressed = default

func get_default():
	return default

func _ready():
	if var_name in Ren.variables:
		default = Ren.get_value(var_name)
	
	else:
		Ren.define(var_name, default)
	
	connect("toggled", self, "on_toggled")
	Ren.connect("var_changed", self, "on_var_changed")

func on_var_changed(varn):
	if var_name != varn:
		return

	pressed = Ren.get_value(var_name)

func on_toggled(value):
	Ren.define(var_name, value)
