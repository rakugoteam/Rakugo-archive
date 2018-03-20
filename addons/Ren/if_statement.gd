extends "statement.gd"

var condition = ""
var is_true

func _init(_condition = ""):
	type = "_if"
	condition = _condition

func enter(dbg = true): 
	if dbg:
		print(debug(kws))
	
	Ren.current_block = self

	return on_enter_block({})

func on_enter_block(new_kwargs = {}):
	if new_kwargs != {}:
		set_kwargs(new_kwargs)

	if is_true == null:
		is_true = Ren.godot.exec(condition)
	
	if is_true:
		get_child(0).enter()
		return
	
	for c in get_children():
		if not(c.type in ["_if", "_elif"]):
			continue
			
		if c.is_true == null:
			c.is_true = Ren.godot.exec(c.condition)

		if c.is_true:
			c.debug()
			c.get_child(0).enter()
			return
	
	if get_children().back().type == "_else":
		var el = get_children().back()
		el.debug()
		el.get_child(0).enter()

func debug(kws = [], some_custom_text = ""):
	return .debug(kws, some_custom_text + condition)



