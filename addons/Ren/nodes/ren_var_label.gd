extends Label

export(String) var var_name = "some_var"
export(String) var default = ""
export(String, "str", "bool", "float", "int") var type = "str" 

func _ready():
	mouse_filter = MOUSE_FILTER_IGNORE
	
	if not (var_name in Ren.variables):
		Ren.define_from_str(var_name, default, type)
	
	var new_val = Ren.get_value(var_name)
	text = str(new_val)
	Ren.connect("var_changed", self, "on_var_changed")

func on_var_changed(varn):
	if var_name != varn:
		return
	
	var new_val = Ren.get_value(var_name)
	text = str(new_val)
