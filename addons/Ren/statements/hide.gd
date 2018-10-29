extends "statement.gd"

func _init():
	._init()
	type = 5 # Ren.StatementType.HIDE
	kws = ["node_id"]

func exec(dbg = true):
	if dbg:
		debug(kws)

	Ren.on_hide(kwargs.node_id)

