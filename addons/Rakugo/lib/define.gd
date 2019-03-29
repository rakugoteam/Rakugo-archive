extends Object
class_name Define

static func invoke(var_name:String, value, save_included: bool, variables: Dictionary) -> RakugoVar:
	if not variables.has(var_name):
		var new_var = RakugoVar.new(var_name, value)
		new_var.save_included = save_included
		variables[var_name] = new_var
		return new_var

	return null
#	else:
#		return set_var(var_name, value)