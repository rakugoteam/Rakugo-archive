## This is Ren API ##
## version: 0.3.0 ##
## License MIT ##
## if class statement ##

extends "statement.gd"

var statements = []
var condition = ""
var conditions = []
var el = null

func _init(_condition = ""):
	type = "_if"
	condition = _condition

func enter(dbg = true): 
	if dbg:
		print(debug(kws))
	
	ren.current_statement_id = id
	ren.current_block = self

	return on_enter_block({})

func on_enter_block(new_kwargs = {}):
	if new_kwargs != {}:
		set_kwargs(new_kwargs)
	
	if ren.godot.exec(condition):
		statements[0].enter()
		return
	
	elif conditions.size() > 0:
		for c in conditions:
			if ren.godot.exec(c.condition):
				c.debug()
				c.statements[0].enter()
				return
	
	elif el != null:
		el.debug()
		el.statements[0].enter()

func debug(kws = [], some_custom_text = ""):
	return .debug(kws, some_custom_text + condition)



