extends Statement
class_name StopAnim

func _init() -> void:
	._init()
	type = 8 # Ren.StatementType.STOP_ANIM
	kws = ["node_id", "reset"]
	kwargs["node_id"] = ""
	kwargs["reset"] = false

func exec(dbg : bool = true) -> void:
	.exec(dbg)
	Ren.on_stop_anim(kwargs.node_id, kwargs.reset)