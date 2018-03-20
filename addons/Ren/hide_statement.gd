extends "statement.gd"

var _node_id

func _init(node_id):
	type = "hide"
	_node_id = node_id

func enter(dbg = true):
	if dbg:
		print(debug(kws))

	Ren.emit_signal("on_hide", _node_id)

	.enter(false)
	on_exit()

func debug(kws = [], some_custom_text = ""):
	return .debug(kws, some_custom_text + _node_id)
