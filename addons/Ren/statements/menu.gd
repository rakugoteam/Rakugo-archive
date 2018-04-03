extends "say.gd"

var title
var choices_labels = []

func _init(_title = null):
	._init()
	kws.append("choices")
	title = _title
	type = "menu"
	
func exec(dbg = true): 
	if dbg:
		print(debug(kws))
	
	choices_labels = []
	for ch in kwargs.choices:
		var l = Ren.text_passer(ch)
		choices_labels.append(l)
	
	Ren.current_menu = self
	
	.exec(false)


func on_exit(_type, new_kwargs):
	if type != _type:
		return

	if new_kwargs != {}:
		set_kwargs(new_kwargs)
	
	if "final_choice" in kwargs:
		Ren.story_state = kwargs.choices[kwargs.final_choice]
	
	else:
		print("no final_choice recived")
	
	.on_exit(type, new_kwargs)
