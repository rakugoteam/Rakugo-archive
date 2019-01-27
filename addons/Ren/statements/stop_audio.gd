extends Statement
class_name StopAudio

func _init() -> void:
	._init()
	type = 10 # Ren.StatementType.STOP_AUDIO
	parameters_names = ["node_id"]
	parameters["node_id"] = ""

func exec(dbg : bool = true) -> void:
	.exec(dbg)
	Ren.on_stop_audio(parameters.node_id)