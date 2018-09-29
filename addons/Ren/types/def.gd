extends Node

const _VAR		= preload("ren_var.gd")
const _CHR		= preload("character_obj.gd")
const _QUEST	= preload("quest.gd")
const _SUBQ		= preload("subquest.gd")

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
		var new_quest = _QUEST.new()
		if typeof(var_value) == TYPE_DICTIONARY:
			new_quest.dict2quest(var_value)
		variables[var_name] = new_quest
		return new_quest
	
	if var_type == Ren.Type.SUBQUEST:
		var new_subquest = _SUBQ.new()
		if typeof(var_value) == TYPE_DICTIONARY:
			new_subquest.dict2subquest(var_value)
		variables[var_name] = new_subquest
		return new_subquest
	
	if var_type == Ren.Type.CHARACTER:
		var new_character = _CHR.new()
		if typeof(var_value) == TYPE_DICTIONARY:
			new_character.dict2character(var_value)
		variables[var_name] = new_character
		return new_character
	
	else:
		var new_var = _VAR.new()
		new_var._type = var_type
		new_var._value = var_value
		variables[var_name] = new_var
		return new_var

		
	
	