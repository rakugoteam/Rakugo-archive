extends Object
class_name Define

static func invoke(var_name:String, value, save_included: bool, variables: Dictionary) -> RakugoVar:
	if not variables.has(var_name):
		var type = typeof(value)
		
		match type:
			TYPE_INT:
				return _rakugo_var(var_name, value, save_included, variables)
				
			TYPE_REAL:
				return _rakugo_var(var_name, value, save_included, variables)
				
			TYPE_BOOL:
				var new_var = RakugoBool.new(var_name, value)
				new_var.save_included = save_included
				variables[var_name] = new_var
				return new_var as RakugoBool
			
			TYPE_ARRAY:
				var new_var = RakugoList.new(var_name, value)
				new_var.save_included = save_included
				variables[var_name] = new_var
				return new_var as RakugoList
			
			TYPE_DICTIONARY:
				var new_var = RakugoDict.new(var_name, value)
				new_var.save_included = save_included
				variables[var_name] = new_var
				return new_var as RakugoDict
			
			TYPE_STRING:
				var new_var = RakugoText.new(var_name, value)
				new_var.save_included = save_included
				variables[var_name] = new_var
				return new_var as RakugoText
				
			_: 
				return null

	return null

static func _rakugo_var(var_name:String , value, save_included: bool, variables: Dictionary) -> RakugoVar :
	var new_var = RakugoVar.new(var_name, value)
	new_var.save_included = save_included
	variables[var_name] = new_var
	return new_var