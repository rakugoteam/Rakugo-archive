extends "say.gd"

var variable = "variable"
var input_variable = "input variable"

func _init():
	._init()
	type = "input"
	kws += ["temp", "input_variable"]

func exec(dbg = true):
	if dbg:
		print(debug(kws))
	
	variable = kwargs.variable
	input_variable = kwargs.input_variable

	if "variable" in kwargs:
		kwargs["variable"] = Ren.text_passer(kwargs.variable)
	
	.exec(false)

func on_exit(_type, new_kwargs = {}):
	if !setup_exit(_type, new_kwargs):
		return
	
	if "variable" in kwargs:
		variable = kwargs.variable
	
	if "input_variable" in kwargs:
		input_variable = kwargs.input_variable
	
	if variable.is_valid_integer():
		variable = int(variable)
	
	elif variable.is_valid_float():
		variable = float(variable)

	Ren.define(input_variable, variable)

	if kwargs.add_to_history:
		add_to_history()

	Ren.story_step()
	
	