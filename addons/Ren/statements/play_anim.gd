extends "statement.gd"

func _init():
	._init()
	type = "play_anim"
	kws = ["node_id", "anim_name", "reset"]
	kwargs["node_id"] = ""
	kwargs["anim_name"] = ""
	kwargs["reset"] = false

func exec(dbg = true):
	.exec(dbg)
	Ren.on_play_anim(kwargs.node_id, kwargs.anim_name, kwargs.reset)



