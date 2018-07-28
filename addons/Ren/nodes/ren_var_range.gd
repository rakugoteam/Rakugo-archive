extends Range

export(String) var var_name = "some_var"

export(float) var default = 0.5 setget set_default, get_default


func set_default(value):
	default = value
	value = default

func get_default():
	return default

func update_properties():
	if Ren.get_variable_type(var_name) == "range":
		min_value = Ren.get_range(var_name, "min_value")
		max_value = Ren.get_range(var_name, "max_value")

func _ready():
	if var_name in Ren.variables:
		value = Ren.get_value(var_name)
		update_properties()
	
	else:
		Ren.range_variable(var_name, min_value, max_value, default)
	
	if !Ren.is_connected("var_changed", self, "on_var_changed"):
		Ren.connect("var_changed", self, "on_var_changed")

func on_var_changed(varn):
	if var_name != varn:
		return
		
	Ren.set_value(var_name, value)
	update_properties()


