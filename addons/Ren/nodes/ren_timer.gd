extends Timer
class_name RenTimer

export(String) var var_name = "some_var"

export(float) var default = 1 setget set_default, get_default


func set_default(value):
	default = value
	wait_time = default

func get_default():
	return default

func _ready():
	if var_name in Ren.variables:
		wait_time = float(Ren.get_value(var_name))
	
	else:
		Ren.define(var_name, default)
	
	Ren.connect_var(var_name, "value_changed", self, "on_value_changed")

func on_value_changed(new_value):
	wait_time = new_value


