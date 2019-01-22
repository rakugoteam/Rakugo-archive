extends Label
class_name RenVarLabel

export(String) var var_name = "some_var"
export(String) var default = ""
export(String, "str", "bool", "float", "int") var type = "str" 

func _ready():
	if not (var_name in Ren.variables):
		Ren.define_from_str(var_name, default, type)
	
	var new_val = Ren.get_value(var_name)
	var var_to_change = Ren.get_var(var_name)
	text = str(new_val)
	var_to_change.connect("value_changed", self, "on_value_changed")

func on_value_changed(new_value):
	text = str(new_value)
