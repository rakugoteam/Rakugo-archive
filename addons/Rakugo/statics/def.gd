extends Node

func get_type(variable) -> String:
	var type = "str"
		
	if typeof(variable) == TYPE_BOOL:
		type = "bool"
	
	if typeof(variable) == TYPE_INT:
		type = "int"
	
	if typeof(variable) == TYPE_REAL:
		type = "float"
	
	return type

func str2rakugo_type(str_type : String) -> int:
	if str_type == "str":
		return Rakugo.Type.TEXT
	
	var lower_types := {}
	for t in Rakugo.Type.keys():
		var lower : String = t.to_lower()
		lower_types[lower] = t

	if str_type in lower_types:
		return Rakugo.Type[lower_types[str_type]]
	
	return Rakugo.Type.VAR

func define_from_str(variables, var_name, var_str, var_type):
	var value = $Def.str2value(var_str, var_type)
	var type = $Def.str2ren_type(var_type)
	return define(variables, var_name, value, type)

func define(variables, var_name, var_value = null, var_type = null):
	if var_value != null && var_type == null:
		var_type = Rakugo.Type.VAR
		var type = typeof(var_value)

		if type == TYPE_STRING:
			var_type = Rakugo.Type.TEXT
		
		if type == TYPE_DICTIONARY:
			var_type = Rakugo.Type.DICT
		
		if type == TYPE_ARRAY:
			var_type = Rakugo.Type.LIST
		
		if type == TYPE_NODE_PATH:
			var_type = Rakugo.Type.NODE
			var_value = var_value

	if var_type == Rakugo.Type.QUEST:
		var new_quest = Quest.new()
		new_quest.quest_id = var_name

		if typeof(var_value) == TYPE_DICTIONARY:
			new_quest.dict2quest(var_value)

		variables[var_name] = new_quest
		return new_quest
	
	if var_type == Rakugo.Type.SUBQUEST:
		var new_subquest = Subquest.new()
		new_subquest.quest_id = var_name

		if typeof(var_value) == TYPE_DICTIONARY:
			new_subquest.dict2subquest(var_value)

		variables[var_name] = new_subquest
		return new_subquest
	
	if var_type == Rakugo.Type.CHARACTER:
		var new_character = CharacterObject.new()

		if typeof(var_value) == TYPE_DICTIONARY:
			new_character.dict2character(var_value)

		variables[var_name] = new_character
		return new_character
	

	var new_var = RakugoVar.new(var_name, var_value, var_type)
	variables[var_name] = new_var
	return new_var
	