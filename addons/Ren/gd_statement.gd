## This is Ren API ##
## version: 0.5.0 ##
## License MIT ##
## g statement class ##

extends "statement.gd"

var code = ""
var code_type = "code"
var changed_values = []

func _init(_code = ""):
	code = _code 
	type = "gd"

func enter(dbg = true):
	if dbg:
		print(debug(kws))
	
	Ren.current_statement_id = id
	on_enter_block()

func on_enter_block(new_kwargs = {}):
	if new_kwargs != {}:
		set_kwargs(new_kwargs)
	
	if changed_values.is_empty():
		var prev_values = Ren.values
		Ren.godot.exec(code, code_type)

		for i in range(Ren.values.size()):
			if i > prev_values.size():
				changed_values.append(Ren.values[i])

			elif Ren.values[i] != prev_values[i]:
				changed_values.append(Ren.values[i])
	
	else:
		for v in changed_values:
			Ren._def.define(Ren.values, v.key, v.value, v.type)


	on_exit()

func debug(kws = [], some_custom_text = ""):
	return .debug(kws, some_custom_text + code)




