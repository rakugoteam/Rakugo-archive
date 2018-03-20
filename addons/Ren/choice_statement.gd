extends "say_statement.gd"


func _init():
	._init()
	type = "choice"

func enter(dbg = true): 
	if dbg:
		print(debug(kws))
	
	on_enter_block()

func on_enter_block(new_kwargs = {}):
	.on_enter_block(new_kwargs)
	if get_child_count() > 0: 
		get_child(0).enter()
	else:
		on_exit()

func on_exit(new_kwargs = {}):
	get_parent().on_exit(new_kwargs)
