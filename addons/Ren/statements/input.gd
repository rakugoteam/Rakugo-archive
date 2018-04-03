extends "say.gd"

func _init():
	type = "input"
	kws = ["who", "what", "temp", "input_value"]

func exec(dbg = true):
	if dbg:
		print(debug(kws))
	
	if "value" in kwargs:
		kwargs["value"] = Ren.text_passer(kwargs.value)
	
	.exec(false)

func on_exit(_type, new_kwargs = {}):
	if _type != type:
		return
	
	if new_kwargs != {}:
		set_kwargs(new_kwargs)

	var value = "value"
	var input_value = "input_value"
	
	if value.is_valid_integer():
		value = int(value)
	
	elif value.is_valid_float():
		value = float(value)

	Ren.define(input_value, value)

	.on_exit(type, new_kwargs)
	
	