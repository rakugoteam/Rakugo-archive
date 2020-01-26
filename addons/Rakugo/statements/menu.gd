extends Say
class_name Menu

var choices_labels: Array = []

func _init() -> void:
	._init()
	parameters_names += ["node", "choices"]
	type = 3 # Rakugo.StatementType.MENU


func if_who(_parameters:Dictionary, _who:CharacterObject):
	.if_who(_parameters, _who)

	if not ("mkind" in _parameters):
		_parameters["mkind"] = _who.mkind

	if not ("mcolumns" in _parameters):
		_parameters["mcolumns"] = _who.mcolumns

	if not ("manchor" in _parameters):
		_parameters["manchor"] = _who.manchor


func if_not_who(_parameters:Dictionary):
	.if_not_who(_parameters)

	if not ("mkind" in _parameters):
		_parameters["mkind"] = Rakugo.default_mkind

	if not ("mcolumns" in _parameters):
		_parameters["mcolumns"] = Rakugo.default_mcolumns

	if not ("manchor" in _parameters):
		_parameters["manchor"] = Rakugo.default_manchor


func exec() -> void:
	Rakugo.checkpoint()
	debug(parameters_names)

	choices_labels = []
	for ch in parameters.choices:
		var l = Rakugo.text_passer(ch)
		choices_labels.append(l)

	.exec()


func on_exit(_type: int, new_parameters: Dictionary = {}) -> void:
	if !setup_exit(_type, new_parameters):
		return

	if "final_choice" in parameters:
		var final_choice: String = parameters.choices.values()[parameters.final_choice]

		var n = parameters.node
		if n:
			n.emit_signal(final_choice)

		else:
			push_warning("no node recived")

	else:
		push_warning("no final_choice recived")

	if parameters.add_to_history:
		add_to_history()

	Rakugo.story_step()
