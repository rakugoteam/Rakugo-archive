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
	
	on_enter_block()

func on_enter_block(new_kwargs = {}):
	if new_kwargs != {}:
		set_kwargs(new_kwargs)
	
	if changed_values.empty():
		var prev_values = Ren.values
		Ren.godot.exec(code, code_type)

		for i in range(Ren.values.size()):
			if i > prev_values.size():
				changed_values.append(Ren.values.values()[i])

			elif Ren.values.values()[i] != prev_values.values()[i]:
				changed_values.append(Ren.valuesvalues()[i])
	
	else:
		for v in changed_values:
			Ren._def.define(Ren.values, v.key, v.value, v.type)


	on_exit()

func debug(kws = [], some_custom_text = ""):
	return .debug(kws, some_custom_text + code)




