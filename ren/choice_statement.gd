## This is RenAPI ##

## version: 0.2.0 ##
## License MIT ##
## Choice class statement ##

extends "say_statement.gd"

var statements = [] # statements after this choice 

func _init(_statemnets):
	._init()
	type = "choice"
	statements = _statements

func enter(dbg = true, new_kwargs = {}):
	if dbg:
		debug(kws)
	
	on_exit(new_kwargs)

func on_exit(new_kwargs = {}):
	if new_kwargs != {}:
		set_kwargs(new_kwargs)
	
	statements[0].enter()