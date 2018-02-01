## This is Ren API ##
## version: 0.5.0 ##
## License MIT ##
## elif statement class ##

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




