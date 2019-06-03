extends Statement
class_name Say

func _init() -> void:
	._init()
	type = 1 # Rakugo.StatementType.SAY
	parameters_names += ["who", "what", "typing", "kind", "avatar", "avatar_state"]
	parameters["who"] = ""
	parameters["add_to_history"] = true
	parameters_always += ["avatar_state"]

func exec() -> void:
	debug(parameters_names)

	if not ("avatar_state" in parameters):
		parameters["avatar_state"] = []

	if not ("who" in parameters):
		parameters["who"] = "Narrator"

	if "who" in parameters:
		if parameters.who in Rakugo.variables:
			if Rakugo.get_type(parameters.who) == Rakugo.Type.CHARACTER:
				var org_who = parameters.who
				var who = Rakugo.get_var(org_who)
				parameters.who = who.parse_name()

				if "avatar" in who.value:
					parameters["avatar"] = who.avatar

				if "what" in parameters:
					parameters.what = who.parse_what(parameters.what)

				if not ("kind" in parameters):
					parameters["kind"] = who.kind

	if "who" in parameters:
		parameters.who = Rakugo.text_passer(parameters.who)

	if "what" in parameters:
		parameters.what = Rakugo.text_passer(parameters.what)

	if not ("kind" in parameters):
		parameters["kind"] = Rakugo.default_kind

	.exec()

func on_exit(_type : int, new_parameters : = {}) -> void:
	Rakugo.story_state += 1
	.on_exit(_type, new_parameters)
