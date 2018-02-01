## This is Ren API ##
## version: 0.5.0 ##
## License MIT ##
## g statement class ##

extends "statement.gd"

var code = ""
var code_type = "code"

func _init(_code = ""):
	code = _code 
	type = "gd"

func enter(dbg = true):
	if dbg:
		print(debug(kws))
	
	ren.current_statement_id = id
	on_enter_block()

func on_enter_block(new_kwargs = {}):
	if new_kwargs != {}:
		set_kwargs(new_kwargs)
	
	ren.godot.exec(code, code_type)

	on_exit()

func debug(kws = [], some_custom_text = ""):
	return .debug(kws, some_custom_text + code)




