## This is Ren API ##
## version: 0.5.0 ##
## License MIT ##
## Menu statement class ##

extends "say_statement.gd"

var title
var choices = [] # list of choices
var choices_labels = []

func _init(_title = null):
	._init()
	title = _title
	type = "menu"
	
func enter(dbg = true): 
	if dbg:
		print(debug(kws))
	
	Ren.current_block = choices

	choices_labels = []
	for ch in choices:
		var l = text_passer(ch.kwargs.what)
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
			
		if choices.size()>kwargs.final_choice:
			choices[kwargs.final_choice].enter()
	
	else:
		print("no final_choice recived")
	

