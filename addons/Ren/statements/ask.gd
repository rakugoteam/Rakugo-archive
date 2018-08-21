extends "say.gd"

var value = "value"
var variable = "variable"

func _init():
	._init()
	type = "ask"
	kws += ["temp", "variable"]

func exec(dbg = true):
	if dbg:
		print(debug(kws))
	
	value = kwargs.value
	variable = kwargs.variable

	if "value" in kwargs:
		kwargs["value"] = Ren.text_passer(kwargs.value)
	
	.exec(false)

func on_exit(_type, new_kwargs = {}):
	if !setup_exit(_type, new_kwargs):
		return
	
	if "value" in kwargs:
		value = kwargs.value
	
	if "variable" in kwargs:
		variable = kwargs.variable
	
	if value.is_valid_integer():
		value = int(value)
	
	elif value.is_valid_float():
		value = float(value)

	Ren.define(variable, value)

	if kwargs.add_to_history:
		add_to_history()

	Ren.story_step()
	
	