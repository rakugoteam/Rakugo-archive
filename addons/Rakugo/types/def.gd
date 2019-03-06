extends Object
class_name RakugoDef

func get_type(variable) -> String:
	var type = "str"
		
	match typeof(variable):
		TYPE_BOOL:
			type = "bool"
		
		TYPE_INT:
			type = "int"
	
		TYPE_REAL:
			type = "float"
	
	return type

func str2rakugo_type(str_type) -> int:
	match str_type:
		"str":
			return Rakugo.Type.TEXT
	
		"character":
			return Rakugo.Type.CHARACTER
	
		"quest":
			return Rakugo.Type.QUEST
	
		"subquest":
			return Rakugo.Type.SUBQUEST
	
		_:
			return Rakugo.Type.VAR

func str2value(str_value : String, var_type : String):
	match var_type:
		"str":
			return str_value
	
		"bool":
			return bool(str_value)
	
		"int":
			return int(str_value)
	
		"float":
			return float(str_value)

func define_from_str(variables : Dictionary, var_name : String, var_str : String, var_type : String):
	var value = str2value(var_str, var_type)
	var type = str2rakugo_type(var_type)
	return define(variables, var_name, value, type)

func define(variables : Dictionary, var_name : String, var_value = null, var_type = null):
	if var_value != null && var_type == null:
		var_type = Rakugo.Type.VAR
		var type = typeof(var_value)

		match type:
			TYPE_STRING:
				var_type = Rakugo.Type.TEXT
		
			TYPE_DICTIONARY:
				var_type = Rakugo.Type.DICT
		
			TYPE_ARRAY:
				var_type = Rakugo.Type.LIST
		
			TYPE_NODE_PATH:
				var_type = Rakugo.Type.NODE
				var_value = var_value

	match var_type:
		Rakugo.Type.QUEST:
			var new_quest = Quest.new()
			new_quest.quest_id = var_name
			
			if is_dict(var_value):
				new_quest.dict2quest(var_value)
				
			variables[var_name] = new_quest
			return new_quest
	
		Rakugo.Type.SUBQUEST:
			var new_subquest = Subquest.new()
			new_subquest.quest_id = var_name
			
			if is_dict(var_value):
				new_subquest.dict2subquest(var_value)
				
			variables[var_name] = new_subquest
			return new_subquest
	
		Rakugo.Type.CHARACTER:
			var new_character = CharacterObject.new()
			
			if is_dict(var_value):
				new_character.dict2character(var_value)
				
			variables[var_name] = new_character
			return new_character
	
		_:
			var new_var = RakugoVar.new(var_name, var_value, var_type)
			variables[var_name] = new_var
			return new_var

		
func is_dict(value) -> bool:
	return typeof(value) == TYPE_DICTIONARY
	