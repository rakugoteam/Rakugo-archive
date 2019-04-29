extends Button

export var var_name : = "some_var" 

export var default : = false setget set_default, get_default

var var_to_change : RakugoVar

func set_default(value : bool) -> void:
	default = value
	pressed = default

func get_default() -> bool:
	return default

func _ready() -> void:
	toggle_mode = true
	
	if var_name in Rakugo.variables:
		default = Rakugo.get_value(var_name)
		var_to_change = Rakugo.get_var(var_name)
	
	else:
		var_to_change = Rakugo.define(var_name, default)
	
	connect("toggled", self, "on_toggled")
	connect("visibility_changed", self, "on_visibility_changed")
	var_to_change.connect("value_changed", self, "on_value_changed")

func on_value_changed(vname:String, new_value:bool) -> void:
	if vname != var_name:
		return
	
	pressed = new_value

func on_toggled(value : bool) -> void:
	var_to_change.value = value

func on_visibility_changed() -> void:
	if visible == false:
		return
		
	pressed = Rakugo.get_value(var_name)
