extends Say
class_name Menu

var choices_labels : Array = []

func _init() -> void:
	._init()
	parameters_names += ["choices"]
	parameters_always += ["choices", "mkind"]
	type = 3 # Rakugo.StatementType.MENU
	parameters["mkind"] = "vertical"

func exec() -> void:
	Rakugo.checkpoint()
	debug(parameters_names)

	choices_labels = []
	for ch in parameters.choices:
		var l = Rakugo.text_passer(ch)
		choices_labels.append(l)

	.exec()

func on_exit(_type : int, new_parameters : Dictionary = {}) -> void:
	if !setup_exit(_type, new_parameters):
		return

	if "final_choice" in parameters:
		var dialog_name : String = parameters.choices.values()[parameters.final_choice]
		Rakugo.jump(Rakugo.current_scene, Rakugo.current_node_name, dialog_name, false)

	else:
		print("no final_choice recived")

	if parameters.add_to_history:
		add_to_history()

	Rakugo.story_step()
