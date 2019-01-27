extends Say
class_name Menu

var choices_labels : Array = []

func _init() -> void:
	._init()
	parameters_names += ["choices"]
	type = 3 # Ren.StatementType.MENU
	parameters["mkind"] = "vertical"
	
func exec(dbg : bool = true) -> void:
	if dbg:
		debug(parameters_names)
	
	choices_labels = []
	for ch in parameters.choices:
		var l = Ren.text_passer(ch)
		choices_labels.append(l)
	
	.exec(false)


func on_exit(_type : int, new_parameters : Dictionary = {}) -> void:
	if !setup_exit(_type, new_parameters):
		return
	
	if "final_choice" in parameters:
		Ren.story_state = parameters.choices[parameters.final_choice]
	
	else:
		print("no final_choice recived")
	
	if parameters.add_to_history:
		add_to_history()

	Ren.story_step()
