## This is Ren API ##

## version: 0.1.0 ##
## License MIT ##
## ren_input statement class ##

extends "say_statement.gd"

func _init():
	type = "input"
	kws = ["how", "what", "temp", "input_value"]

func use(dbg = true):
	if dbg:
		debug(kws)
	
	if "value" in kwargs:
		kwargs.value = text_passer(kwargs.value)
	
	.use(false)

# func next(new_kwargs = {}):
# 	if new_kwargs != {}:
# 		set_kwargs(new_kwargs)

	var type = "text"
	var value = kwargs.value
	var input_value = kwargs.input_value
	
	if value.is_valid_integer():
		value = int(value)
	
	elif value.is_valid_float():
		value = float(value)

	if typeof(value) != TYPE_STRING:
		type = "var"
	
	ren.values[input_value] = {"type":type, "value":value}
	
	# .next({})