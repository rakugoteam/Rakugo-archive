## This is Ren API ##

## version: 0.2.0 ##
## License MIT ##
## Menu class statement ##

extends "say_statement.gd"

var title
var choices = [] # list of choice("first_choice", list_of_stuff_to_happen_after_this_choice)
var choices_labels = []

func _init(_choices, _title = null):
	._init()
	title = _title
	choices = _choices
	type = "menu"
	
func enter(dbg = true, new_kwargs = {}):
	if dbg:
		debug(kws)
	
	ren.current_statemnet_id = id
	ren.current_block_id = id

	choices_labels = []
	for ch in choices:
		var l = text_passer(ch.kwargs.what)
		choices_labels.append(l)
	
	.enter(false)

func on_exit(new_kwargs = {}):
	if new_kwargs != {}:
		set_kwargs(new_kwargs)
	
	if "final_choice" in kwargs:
		ren.disconnect("exit_statement", self, "on_exit")
		choices[kwargs.final_choice].enter()
	
	else:
		print("no final_choice recived")
		return

	.on_exit({})