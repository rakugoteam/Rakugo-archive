## This is Ren API ##
## version: 0.3.0 ##
## License MIT ##
## else class statement ##

extends "statement.gd"

var statements = []

func _init():
	type = "_else"

func enter(dbg = true): 
	if dbg:
		print(debug(kws))
	
	ren.current_statement_id = id
	ren.current_block = self

	on_enter_block({})





