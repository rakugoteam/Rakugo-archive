extends "statement.gd"

var condition = ""
var is_true

func _init(_condition = ""):
	condition = _condition 
	type = "_elif"

func enter(dbg = true): 
	if dbg:
		print(debug(kws))
	
	Ren.current_block = self

	on_enter_block({})

func debug(kws = [], some_custom_text = ""):
	return .debug(kws, some_custom_text + condition)




