## This is Ren API ##

## version: 0.2.0 ##
## License MIT ##
## Menu class statement ##

extends "say_statement.gd"

# todo change in to kwargs
var title
var choices = [] # list of choice("first_choice", list_of_stuff_to_happen_after_this_choice)
var choices_labels = []

func _init(_title = null):
	._init()
	title = _title
	type = "menu"
	
func enter(dbg = true): 
	if dbg:
		print(debug(kws))
	
	ren.current_block = choices

	choices_labels = []
	for ch in choices:
		var l = text_passer(ch.kwargs.what)
		choices_labels.append(l)
	
	ren.current_menu = self
	
	.enter(false)

func on_enter_block(new_kwargs = {}):
	if new_kwargs != {}:
		set_kwargs(new_kwargs)
	
	if "final_choice" in kwargs:
		ren.disconnect("exit_statement", self, "on_exit")
		choices[kwargs.final_choice].enter()
	
	else:
		print("no final_choice recived")
