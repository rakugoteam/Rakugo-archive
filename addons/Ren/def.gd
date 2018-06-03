extends Node

func get_type(variable):
	var type = "str"
		
	if typeof(variable) == TYPE_BOOL:
		type = "bool"
	
	elif typeof(variable) == TYPE_INT:
		type = "int"
	
	elif typeof(variable) == TYPE_REAL:
		type = "float"
	
	return type

func define_from_str(variables, var_name, var_str, var_type):
	if var_type == "str":
		define(variables, var_name, var_str, "text")
	
	elif var_type == "bool":
		define(variables, var_name, bool(var_str), "var")
	
	elif var_type == "int":
		define(variables, var_name, int(var_str), "var")
	
	elif var_type == "float":
		define(variables, var_name, float(var_str), "var")

func define(variables, var_name, var_value = null, var_type = null):
	if var_value != null && var_type == null:
		var_type = "var"
		var type = typeof(var_value)

		if type == TYPE_STRING:
			var_type = "text"
		
		elif type == TYPE_DICTIONARY:
			var_type = "dict"
		
		elif type == TYPE_ARRAY:
			var_type = "list"
		
		elif type == TYPE_NODE_PATH:
			var_type = "node"
			var_value = get_node(var_value)
		
	variables[var_name] = {"type":var_type, "value":var_value}
