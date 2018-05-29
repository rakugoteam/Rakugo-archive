extends "say.gd"

var choices_labels = []

func _init():
	._init()
	kws += ["choices"]
	type = "menu"
	kwargs["mkind"] = "vertical"
	
func exec(dbg = true): 
	if dbg:
		print(debug(kws))
	
	choices_labels = []
	for ch in kwargs.choices:
		var l = Ren.text_passer(ch)
		choices_labels.append(l)
	
	.exec(false)


func on_exit(_type, new_kwargs):
	if !setup_exit(_type, new_kwargs):
		return
	
	if "final_choice" in kwargs:
		Ren.story_state = kwargs.choices[kwargs.final_choice]
	
	else:
		print("no final_choice recived")
	
	if kwargs.add_to_history:
		add_to_history()

	Ren.story_step()
