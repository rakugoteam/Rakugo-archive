extends Statement
class_name PlayAnim

func _init():
	._init()
	type = 7 # Ren.StatementType.PLAY_ANIM
	kws = ["node_id", "anim_name"]
	kwargs["node_id"] = ""
	kwargs["anim_name"] = ""

func exec(dbg = true):
	.exec(dbg)
	Ren.on_play_anim(kwargs.node_id, kwargs.anim_name)