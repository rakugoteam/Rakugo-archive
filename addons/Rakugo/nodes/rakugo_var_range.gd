extends Range

# class_name RakugoVarRange - there is no need for that
# we don't want it be be seen in "add new Node" dialog,
# but to seen other Nodes that use it

export var var_name := "some_var"
export var default := 0.5 setget set_default, get_default

func set_default(value: float) -> void:
	default = value
	value = default


func get_default() -> float:
	return default


func _ready() -> void:
	if var_name in Rakugo.variables:
		value = float(Rakugo.get_value(var_name))
	
	else:
		Rakugo.define(var_name, default)
	
	Rakugo.connect_var(var_name, "value_changed", self, "on_value_changed")
	connect("visibility_changed", self, "on_visibility_changed")


func on_value_changed(vname: String, new_value: float) -> void:
	if vname != var_name:
		return
		
	value = new_value


func on_visibility_changed() -> void:
	if visible == false:
		return
		
	value = Rakugo.get_value(var_name)
