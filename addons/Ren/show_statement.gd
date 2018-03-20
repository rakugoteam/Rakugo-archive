extends "statement.gd"

var _node_id
var _state = []

func _init(node_id, state = []):
	type = "show"
	kws = ["x", "y", "z", "at", "pos"]
	_node_id = node_id
	_state = state

func is_procent(x):
	return (typeof(x) == TYPE_REAL
			and x >= 0.0
			and x <= 1.0)

func enter(dbg = true):
	if dbg:
		print(debug(kws))
	
	if "at" in kwargs:
		if "center" in kwargs.at:
			kwargs.x = 0.5
			
		if "left" in kwargs.at:
			kwargs.x = 0.0

		if "right" in kwargs.at:
			kwargs.x = 1.0

	if "at" in kwargs:
		if "center" in kwargs.at:
			kwargs.y = 0.5
			
		if "top" in kwargs.at:
			kwargs.y = 0.0

		if "bottom" in kwargs.at:
			kwargs.y = 1.0

	Ren.emit_signal("on_show", _node_id, _state, kwargs)
		
	.enter(false)
	on_exit()

func debug(kws = [], some_custom_text = ""):
	return .debug(kws, some_custom_text + _node_id)

