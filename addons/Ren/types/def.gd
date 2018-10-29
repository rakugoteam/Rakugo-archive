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

func str2ren_type(str_type):
	if str_type == "str":
		return Ren.Type.TEXT
	
	elif str_type == "character":
		return Ren.Type.CHARACTER
	
	elif str_type == "quest":
		return Ren.Type.QUEST
	
	elif str_type == "subquest":
		return Ren.Type.SUBQUEST
	
	else:
		return Ren.Type.VAR

func str2value(str_value, var_type):
	if var_type == "str":
		return str_value
	
	elif var_type == "bool":
		return bool(str_value)
	
	elif var_type == "int":
		return int(str_value)
	
	elif var_type == "float":
		return float(str_value)

func define_from_str(variables, var_name, var_str, var_type):
	var value = str2value(var_str, var_type)
	var type = str2ren_type(var_type)
	return define(variables, var_name, value, type)

func define(variables, var_name, var_value = null, var_type = null):
	if var_value != null && var_type == null:
		var_type = Ren.Type.VAR
		var type = typeof(var_value)

		if type == TYPE_STRING:
			var_type = Ren.Type.TEXT
		
		elif type == TYPE_DICTIONARY:
			var_type = Ren.Type.DICT
		
		elif type == TYPE_ARRAY:
			var_type = Ren.Type.LIST
		
		elif type == TYPE_NODE_PATH:
			var_type = Ren.Type.NODE
			var_value = get_node(var_value)
	
	if var_type == Ren.Type.QUEST:
		return Ren.quest(var_name, var_value)
	
	if var_type == Ren.Type.SUBQUEST:
		return Ren.subquest(var_name, var_value)
	
	if var_type == Ren.Type.CHARACTER:
		return Ren.character(new_character, var_value)
	
	else:
		return define(Ren.variables, var_name, var_value, var_type)

		
	
	