extends "say_statement.gd"

var temp = "" setget _set_temp, _get_temp
var input_value =""
var value

func _init():
	type = "input"
	kws = ["who", "what", "temp", "input_value"]

func _set_temp(value):
	kwargs.temp = value

func _get_temp():
	return kwargs.temp

func _set_input_value(value):
	kwargs.input_value = value

func _get_input_value():
	return kwargs.input_value

func enter(dbg = true):
	if dbg:
		print(debug(kws))
	
	if "value" in kwargs:
		kwargs.value = Ren.text_passer(kwargs.value)
	
	return .enter(false)

func on_exit(new_kwargs = {}):
	if new_kwargs != {}:
		set_kwargs(new_kwargs)

	var value = kwargs.value
	
	if value.is_valid_integer():
		value = int(value)
	
	elif value.is_valid_float():
		value = float(value)

	Ren.define(input_value, value)
	
	.on_exit(new_kwargs)