extends "statement.gd"

func _init():
	._init()
	type = 8 # Ren.StatementType.STOP_ANIM
	kws = ["node_id"]
	kwargs["node_id"] = ""

func exec(dbg = true):
	.exec(dbg)
	Ren.on_stop_anim(kwargs.node_id)