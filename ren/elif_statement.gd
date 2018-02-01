## This is Ren API ##
## version: 0.3.0 ##
## License MIT ##
## elif class statement ##

extends "statement.gd"

var statements = []
var condition = ""

func _init(_condition = ""):
	condition = _condition 
	type = "_elif"

func enter(dbg = true): 
	if dbg:
		print(debug(kws))
	
	ren.current_statement_id = id
	ren.current_block = self

	on_enter_block({})

func debug(kws = [], some_custom_text = ""):
	return .debug(kws, some_custom_text + condition)




