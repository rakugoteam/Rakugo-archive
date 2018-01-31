## This is Ren API ##
## version: 0.3.0 ##
## License MIT ##
## elif class statement ##

extends "if_statement.gd"

func _init(_condition = ""):
	._init(_condition)
	type = "_elif"

func enter(dbg = true): 
	if dbg:
		print(debug(kws))
	
	ren.current_statement_id = id
	ren.current_block = self

	on_enter_block({})

func on_enter_block(new_kwargs = {}):
	if new_kwargs != {}:
		set_kwargs(new_kwargs)
	
	if ren.godot.exec(condition):
		statements[0].enter()
		return
	
	elif conditions.size() > 0:
		for c in conditions:
			if ren.godot.exec(c):
				c.statements[0].enter()
				break
	
	elif el != null:
		el.statements[0].enter()




