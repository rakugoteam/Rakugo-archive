extends Statement
class_name PlayAnim

func _init() -> void:
	._init()
	type = 7 # Ren.StatementType.PLAY_ANIM
	parameters_names = ["node_id", "anim_name"]
	parameters["node_id"] = ""
	parameters["anim_name"] = ""

func exec() -> void:
	.exec()
	Ren.on_play_anim(parameters.node_id, parameters.anim_name)