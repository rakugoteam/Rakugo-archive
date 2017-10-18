## This is Ren API ##

## version: 0.1.0 ##
## License MIT ##
## ren_input statement class ##

extends "res://ren/statement.gd"

func _init(kwargs):
	type = "input"
	kws = ["ivar", "what", "temp", "vars"]
	._init(kwargs)

func use():
	if "what" in kwargs:
		kwargs.what = text_passer(kwargs.what)
	
	if temp in _kwargs:
		kwargs.temp = text_passer(kwargs.temp)

	.use(false)

func next():
	var type = "text"
	var value = kwargs.value
	var input_var = kwargs.input_var
	
	if value.is_valid_integer():
		value = int(value)
	
	elif value.is_valid_float():
		value = float(value)

	if typeof(value) != TYPE_STRING:
		type = "var"
	
	if vars in kwargs:
		kwargs.vars[input_var] = {"type":type, "value":value}
	
	.next()