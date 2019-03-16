extends Timer
class_name RakugoTimer

export var var_name : = "some_var"

export var default : = 1.0 setget set_default, get_default

func set_default(value : float) -> void:
	default = value
	wait_time = default

func get_default() -> float:
	return default

func _ready() -> void:
	if var_name in Rakugo.variables:
		reset()
	
	else:
		Rakugo.define(var_name, default)
	
	Rakugo.connect_var(var_name, "value_changed", self, "on_value_changed")

func on_value_changed(vname:String, new_value:float) -> void:
	if var_name != vname:
		return
		
	if new_value == 0:
		new_value = 0.1
		
	wait_time = new_value

func reset():
	wait_time = float(Rakugo.get_value(var_name))
