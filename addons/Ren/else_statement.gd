extends "statement.gd"


func _init():
	type = "_else"

func enter(dbg = true): 
	if dbg:
		print(debug(kws))

	Ren.current_block = self

	on_enter_block({})

func debug(kws = [], some_custom_text = ""):
	if get_parent() != null:
		return .debug(kws, some_custom_text + "not ( " + get_parent().condition + ")")




