## This is Ren API ##
## version: 0.5.0 ##
## License MIT ##
## ren_input statement class ##

extends "say_statement.gd"

func _init():
	type = "input"
	kws = ["how", "what", "temp", "input_value"]

func enter(dbg = true):
	if dbg:
		print(debug(kws))
	
	if "value" in kwargs:
		kwargs.value = text_passer(kwargs.value)
	
	.enter(false)

func on_exit(new_kwargs = {}):
	if new_kwargs != {}:
		set_kwargs(new_kwargs)

	var value = kwargs.value
	var input_value = kwargs.input_value
	
	if value.is_valid_integer():
		value = int(value)
	
	elif value.is_valid_float():
		value = float(value)

	ren.define(input_value, value)
	
	.on_exit(new_kwargs)