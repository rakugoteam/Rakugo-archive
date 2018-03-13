## This is Ren API ##
## version: 0.5.0 ##
## License MIT ##

extends Node

func get_type(val):
	var type = "str"
		
	if typeof(val) == TYPE_BOOL:
		type = "bool"
	
	elif typeof(val) == TYPE_INT:
		type = "int"
	
	elif typeof(val) == TYPE_REAL:
		type = "float"
	
	return type

func define_from_str(values, val_name, val_str, val_type):
	if val_type == "str":
		define(values, val_name, val_str, "text")
	
	elif val_type == "bool":
		define(values, val_name, bool(val_str), "var")
	
	elif val_type == "int":
		define(values, val_name, int(val_str), "var")
	
	elif val_type == "float":
		define(values, val_name, float(val_str), "var")

func define(values, val_name, val_value = null, val_type = null):
	if val_value != null && val_type == null:
		val_type = "var"
		var type = typeof(val_value)

		if type == TYPE_STRING:
			val_type = "text"
		
		elif type == TYPE_DICTIONARY:
			val_type = "dict"
		
		elif type == TYPE_ARRAY:
			val_type = "list"
		
		elif type == TYPE_NODE_PATH:
			val_type = "node"
			val_value = get_node(val_value)
		
	values[val_name] = {"type":val_type, "value":val_value}
