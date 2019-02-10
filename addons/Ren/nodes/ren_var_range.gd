extends Range
# class_name RenVarRange - there is no need for that
# we don't want it be be seen in "add new Node" dialog,
# but to seen other Nodes that use it
export var var_name : = "some_var"
export var default : = 0.5 setget set_default, get_default


func set_default(value : float) -> void:
	default = value
	value = default

func get_default() -> float:
	return default

func _ready() -> void:
	if var_name in Ren.variables:
		value = float(Ren.get_value(var_name))
	
	else:
		Ren.define(var_name, default)
	
	Ren.connect_var(var_name, "value_changed", self, "on_value_changed")

func on_value_changed(new_value : float) -> void:
	value = new_value


