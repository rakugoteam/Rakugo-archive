extends "say_statement.gd"

var title
var choices_labels = []

func _init(_title = null):
	._init()
	title = _title
	type = "menu"
	
func enter(dbg = true): 
	if dbg:
		print(debug(kws))
	
	choices_labels = []
	for ch in get_children():
		var l = Ren.text_passer(ch.kwargs.what)
		choices_labels.append(l)
	
	Ren.current_menu = self
	
	.enter(false)

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
	

