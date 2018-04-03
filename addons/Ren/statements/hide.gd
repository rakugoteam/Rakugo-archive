extends "statement.gd"


func _init():
	type = "hide"
	kws = ["node_id"]

func exec(dbg = true):
	if dbg:
		print(debug(kws))

	Ren.on_hide(kwargs.node_id)

	.exec(false)
	Ren.timer.start()

