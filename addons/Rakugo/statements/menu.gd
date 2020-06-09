extends Say
class_name Menu

var choices_labels: Array = []

func _init() -> void:
	._init()
	type = 3 # Rakugo.StatementType.MENU
	parameters_names += ["node", "choices",	"mkind", "manchor","mcolumns"]
	def_parameters["typing"] = false
	def_parameters["mkind"] = "vertical"
	def_parameters["manchor"] = "center"


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
