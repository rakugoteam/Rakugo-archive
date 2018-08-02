extends "say.gd"

var value = "value"
var input_variable = "input variable"

func _init():
	._init()
	type = "ask"
	kws += ["temp", "input_variable"]

func exec(dbg = true):
	if dbg:
		print(debug(kws))
	
	value = kwargs.value
	input_variable = kwargs.input_variable

	if "value" in kwargs:
		kwargs["value"] = Ren.text_passer(kwargs.value)
	
	.exec(false)

func on_exit(_type, new_kwargs = {}):
	if !setup_exit(_type, new_kwargs):
		return
	
	if "value" in kwargs:
		value = kwargs.value
	
	if "input_variable" in kwargs:
		input_variable = kwargs.input_variable
	
	if value.is_valid_integer():
		value = int(value)
	
	elif value.is_valid_float():
		value = float(value)

	Ren.define(input_variable, value)

	if kwargs.add_to_history:
		add_to_history()

	Ren.story_step()
	
	