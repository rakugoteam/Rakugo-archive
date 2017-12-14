## This is RenAPI ##

## version: 0.2.0 ##
## License MIT ##
## Choice class statement ##

extends "say_statement.gd"

var statements = [] # statements after this choice 

func _init():
	._init()
	type = "choice"

func enter(dbg = true): 
	if dbg:
		print(debug(kws))
	
	on_exit()

func on_exit(new_kwargs = {}):
	if new_kwargs != {}:
		set_kwargs(new_kwargs)
	
	if ren.is_connected("exit_statement", self, "on_exit"):
		ren.disconnect("exit_statement", self, "on_exit")
	
	statements[0].enter()
