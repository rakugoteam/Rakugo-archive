extends Statement
class_name Say

func _init() -> void:
	._init()
	type = 1 # Rakugo.StatementType.SAY
	parameters_names += ["who", "what", "typing", "kind", "avatar", "avatar_state"]
	def_parameters["add_to_history"] = true
	def_parameters["who"] = "Narrator"
	def_parameters["what"] = ""
	def_parameters["typing"] = true
	def_parameters["kind"] = "adv"
	def_parameters["avatar"] = ""
	def_parameters["avatar_state"] = ""


func if_who(_parameters:Dictionary, _who:CharacterObject):
	if "avatar" in _who.value:
		_parameters["avatar"] = _who.avatar

	if "what" in _parameters:
		_parameters.what = _who.parse_what(_parameters.what)

	if not ("kind" in _parameters):
		_parameters["kind"] = _who.kind


func if_not_who(_parameters:Dictionary):
	if "who" in _parameters:
		_parameters.who = Rakugo.text_passer(_parameters.who)

	if "what" in _parameters:
		_parameters.what = Rakugo.text_passer(_parameters.what)

	if not ("kind" in _parameters):
		_parameters["kind"] = Rakugo.default_kind


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

				if_who(parameters, who)


	if_not_who(parameters)

	.exec()

func on_exit(_type: int, new_parameters := {}) -> void:
	Rakugo.story_state += 1
	.on_exit(_type, new_parameters)
