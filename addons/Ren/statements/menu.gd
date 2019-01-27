extends Say
class_name Menu

var choices_labels : Array = []

func _init() -> void:
	._init()
	kws += ["choices"]
	type = 3 # Ren.StatementType.MENU
	kwargs["mkind"] = "vertical"
	
func exec(dbg : bool = true) -> void:
	if dbg:
		debug(kws)
	
	choices_labels = []
	for ch in kwargs.choices:
		var l = Ren.text_passer(ch)
		choices_labels.append(l)
	
	.exec(false)


func on_exit(_type : int, new_kwargs : Dictionary = {}) -> void:
	if !setup_exit(_type, new_kwargs):
		return
	
	if "final_choice" in kwargs:
		Ren.story_state = kwargs.choices[kwargs.final_choice]
	
	else:
		print("no final_choice recived")
	
	if kwargs.add_to_history:
		add_to_history()

	Ren.story_step()
