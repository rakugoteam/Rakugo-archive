extends Label
class_name RakugoVarLabel

export var var_name : = "some_var"
export var default = ""
export(String, "str", "bool", "float", "int") var type : = "str" 

func _ready() -> void:
	if not (var_name in Rakugo.variables):
		Rakugo.define_from_str(var_name, default, type)
	
	var new_val = Rakugo.get_value(var_name)
	var var_to_change = Rakugo.get_var(var_name)
	text = str(new_val)
	var_to_change.connect("value_changed", self, "on_value_changed")
	connect("visibility_changed", self, "on_visibility_changed")

func on_value_changed(vname:String, new_value) -> void:
	if vname != var_name:
		return
		
	text = str(new_value)

func on_visibility_changed() -> void:
	if visible == false:
		return
		
	text = str(Rakugo.get_value(var_name))
