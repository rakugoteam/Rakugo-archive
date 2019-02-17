extends Statement
class_name Say

func _init() -> void:
	._init()
	type = 1 # Ren.StatementType.SAY
	parameters_names += ["who", "what", "typing", "kind"]
	parameters["typing"] = true
	parameters["who"] = ""
	parameters["add_to_history"] = true

func exec() -> void:
	debug(parameters_names)
	
	if "who" in parameters:
		if parameters.who in Ren.variables:
			if Ren.get_type(parameters.who) == Ren.Type.CHARACTER:
				var org_who = parameters.who
				var who = Ren.get_character(org_who)
				parameters.who = who.parse_character()
				
				if "avatar" in Ren.get_character(org_who).value:
					parameters["avatar"] = Ren.get_character(org_who).avatar
				
				if "what" in parameters:
					parameters.what = who.parse_what(parameters.what)
	
	if "who" in parameters:
		parameters.who = Ren.text_passer(parameters.who)
	
	if "what" in parameters:
		parameters.what = Ren.text_passer(parameters.what)
	
	.exec()
