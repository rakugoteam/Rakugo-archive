## This is RenAPI ##
## version: 0.5.0 ##
## License MIT ##
## Choice statement class ##

extends "say_statement.gd"

var statements = [] # statements after this choice 

func _init():
	._init()
	type = "choice"

func enter(dbg = true): 
	if dbg:
		print(debug(kws))
	
	on_enter_block()

func on_enter_block(new_kwargs = {}):
	.on_enter_block(new_kwargs)
	if statements.size()>0:
		statements[0].enter()

func on_exit(new_kwargs = {}):
	condition_statement.on_exit(new_kwargs)
