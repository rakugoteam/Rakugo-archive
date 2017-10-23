## This is Ren API ##

## version: 0.1.0 ##
## License MIT ##
## Menu class statement ##

extends "say_statement.gd"

func _init():
	type = "menu"
	kws = ["how", "what", "choices", "menu_name"]

func use(dbg = true):
	if dbg:
		debug(kws)

	if choices in kwargs:
			kwargs["raw_choices"] = []
			for ch in kwargs.choices:
				kwargs.raw_choices.append(ch)
				ch = text_passer(ch)
		
	.use(false)

func next(new_kwargs = {}):
	if new_kwargs != {}:
		set_kwargs(new_kwargs)
		
	.next({})
