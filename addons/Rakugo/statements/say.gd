extends Statement
class_name Say

func _init() -> void:
	._init()
	type = 1 # Rakugo.StatementType.SAY
	parameters_names += ["who", "what", "typing", "kind"]
	parameters["who"] = ""
	parameters["add_to_history"] = true
	parameters["kind"] = "adv"

func exec() -> void:
	debug(parameters_names)
	
	if "who" in parameters:
		if parameters.who in Rakugo.variables:
			if Rakugo.get_type(parameters.who) == Rakugo.Type.CHARACTER:
				var org_who = parameters.who
				var who = Rakugo.get_character(org_who)
				parameters.who = who.parse_character()
				
				if "avatar" in Rakugo.get_character(org_who).value:
					parameters["avatar"] = Rakugo.get_character(org_who).avatar
				
				if "what" in parameters:
					parameters.what = who.parse_what(parameters.what)
	
	if "who" in parameters:
		parameters.who = Rakugo.text_passer(parameters.who)
	
	if "what" in parameters:
		parameters.what = Rakugo.text_passer(parameters.what)
	
	.exec()

func on_exit(_type : int, new_parameters : = {}) -> void:
	Rakugo.story_state += 1
	.on_exit(_type, new_parameters)