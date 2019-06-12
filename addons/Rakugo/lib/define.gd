extends Object

func invoke(var_name:String, value, save_included: bool) -> RakugoVar:
	var variables = Rakugo.variables

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
				if value.is_valid_html_color():
					var c = _color(var_name, value.to_html(), save_included, variables)
					return c as RakugoColor

				var new_var = RakugoText.new(var_name, value)
				new_var.save_included = save_included
				variables[var_name] = new_var
				return new_var as RakugoText

			TYPE_NODE_PATH:
				return node_link(var_name, value, variables) as NodeLink

			TYPE_VECTOR2:
				var new_var = RakugoVector2.new(var_name, value)
				new_var.save_included = save_included
				variables[var_name] = new_var
				return new_var as RakugoVector2

			TYPE_VECTOR3:
				var new_var = RakugoVector3.new(var_name, value)
				new_var.save_included = save_included
				variables[var_name] = new_var
				return new_var as RakugoVector3

			TYPE_COLOR:
				var c = _color(var_name, value.to_html(), save_included, variables)
				return c as RakugoColor

			_:
				return null

	return null

func _rakugo_var(var_name:String , value, save_included: bool, variables: Dictionary) -> RakugoVar :
	var new_var = RakugoVar.new(var_name, value)
	new_var.save_included = save_included
	variables[var_name] = new_var
	return new_var

func node_link(node_id:String, node_path: NodePath, variables:Dictionary) -> NodeLink:
	var node_var = NodeLink.new(node_id)
	node_var.value["node_path"] = node_path
	variables[node_var.id] = node_var
	return node_var

func _color(var_name:String , value:String, save_included: bool, variables:Dictionary) -> RakugoColor:
	var new_var = RakugoColor.new(var_name, value)
	new_var.save_included = save_included
	variables[var_name] = new_var
	return new_var
