extends Label

export(String) var val_name = ""
export(String) var default = ""
export(String, "str", "bool", "float", "int") var type = "str" 

func _ready():
	mouse_filter = MOUSE_FILTER_IGNORE
	
	if not (val_name in Ren.values):
		Ren.define_from_str(val_name, default, type)
	
	var new_val = Ren.get_value(val_name)
	text = str(new_val)
	Ren.connect("val_changed", self, "on_val_changed")

func on_val_changed(valn):
	if val_name != valn:
		return
	
	var new_val = Ren.get_value(val_name)
	text = str(new_val)
