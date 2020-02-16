extends Statement
class_name StopAnim

func _init() -> void:
	._init()
	type = 8 # Rakugo.StatementType.STOP_ANIM
	parameters_names = ["node_id", "reset"]
	parameters["node_id"] = ""
	parameters["reset"] = false


func exec() -> void:
	.exec()
	Rakugo.on_stop_anim(parameters.node_id, parameters.reset)
