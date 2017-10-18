## This is Ren'GD API ##

## version: 0.1.0 ##
## License MIT ##
## Say class statement ##

extends "res://RenGD/statement.gd"

func _init(kwargs, index, statments):
	type = "say"
	kws = ["how", "what"]
	._init(kwargs, index, statments)

func use():
	
	if "how" in kwargs:
		if kwargs.how.type == "Character":
			how = kwargs.how.value
			kwargs.how = how.parse_character(kwargs.values)
			kwargs.what = how.parse_what(kwargs.what)
	
	if what in _kwargs:
	    kwargs.what = text_passer(kwargs.what, kwargs.values)
	
	.use()
	
	set_process_input(true) ## move to gui

## move to gui
func _input(event):
	if event.is_action_released("ren_rollforward"):
		next()

func next():
	set_process_input(false) ## move to gui
	.next()