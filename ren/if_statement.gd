## This is Ren API ##

## version: 0.2.0 ##
## License MIT ##
## if class statement ##

extends "statement.gd"

var case
var cases = []

func _init(case):
	._init()
	type = "if"

func enter(dbg = true): 
	if dbg:
		print(debug(kws))
	
	ren.current_block = self
	
	.enter(false)

func on_enter_block(new_kwargs = {}):
	if new_kwargs != {}:
		set_kwargs(new_kwargs)
	


