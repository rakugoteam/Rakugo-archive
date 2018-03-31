extends "statement.gd"

func _init():
	type = "jump"
	kws = ["block", "statement_id", "dialog"]

func enter(dbg = true): 
	# todo
	if dbg:
		print(debug(kws))
	
	if "statement_id" in kwargs:
		if "block" in kwargs:
			kwargs.block.get_child(kwargs.statement_id).enter()
	
		else:
			Ren.get_child(kwargs.statement_id).enter()

func debug(kws = [], some_custom_text = ""):
	var dbg = str(get_index()) + ":" + type + "(" + some_custom_text
	dbg += ", statement_id: " + str(kwargs.statement_id) + ")"
	print(dbg)