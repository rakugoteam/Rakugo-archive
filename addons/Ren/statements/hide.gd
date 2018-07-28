extends "statement.gd"

func _init():
	type = "hide"
	kws = ["node_id"]

func exec(dbg = true):
	kwargs["add_to_history"] = false
	.exec(dbg)

	Ren.on_hide(kwargs.node_id)

