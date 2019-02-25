extends Label
class_name RenVarLabel

export var var_name : = "some_var"
export var default = ""
export(String, "str", "bool", "float", "int") var type : = "str" 

func _ready() -> void:
	if not (var_name in Ren.variables):
		Ren.define_from_str(var_name, default, type)
	
	var new_val = Ren.get_value(var_name)
	var var_to_change = Ren.get_var(var_name)
	text = str(new_val)
	var_to_change.connect("value_changed", self, "on_value_changed")
	connect("visibility_changed", self, "on_visibility_changed")

func on_value_changed(new_value) -> void:
	text = str(new_value)

func on_visibility_changed() -> void:
	if visible == false:
		return
		
	text = str(Ren.get_value(var_name))
