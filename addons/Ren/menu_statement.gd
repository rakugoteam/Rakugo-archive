extends "say_statement.gd"

var title = ""
var choices_labels = []
var choices = []
var final_choice = -1

func _get_final_choice():
	if "final_choice" in kwargs:
		return kwargs.final_choice
	
	return -1

func add_choice(choice = {"who":"", "what":"some choice"}):
	choices.append(choice)

func _init(_title = ""):
	._init()
	title = _title
	type = "menu"
	
func enter(dbg = true): 
	if dbg:
		print(debug(kws))
	
	choices_labels = []
	# for ch in get_children():
	# 	var l = Ren.text_passer(ch.kwargs.what)
	# 	choices_labels.append(l)
	for ch in choices:
		if "what" in ch:
			var l = Ren.text_passer(ch.what)
			choices_labels.append(l)
	
	Ren.current_menu = self
	
	return .enter(false)

func on_enter_block(new_kwargs = {}):
	if new_kwargs != {}:
		set_kwargs(new_kwargs)
	
	if "final_choice" in kwargs:
		if Ren.is_connected("exit_statement", self, "on_exit"):
			Ren.disconnect("exit_statement", self, "on_exit")
		
		if not (self in Ren.history):
			Ren.history.append(self)
			
		if get_child_count() > new_kwargs.final_choice:
			get_child(kwargs.final_choice).enter()
	
	else:
		print("no final_choice recived")
	

