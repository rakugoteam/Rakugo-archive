extends "say.gd"

var value = "value"
var input_value = "input value"

func _init():
	type = "input"
	kws = ["who", "what", "temp", "input_value"]

func exec(dbg = true):
	if dbg:
		print(debug(kws))
	
	value = kwargs.value
	input_value = kwargs.input_value

	if "value" in kwargs:
		kwargs["value"] = Ren.text_passer(kwargs.value)
	
	.exec(false)

func on_exit(_type, new_kwargs = {}):
	if !setup_exit(_type, new_kwargs):
		return
	
	if "value" in kwargs:
		value = kwargs.value
	
	if "input_value" in kwargs:
		input_value = kwargs.input_value
	
	if value.is_valid_integer():
		value = int(value)
	
	elif value.is_valid_float():
		value = float(value)

	Ren.define(input_value, value)

	Ren.story_step()
	
	