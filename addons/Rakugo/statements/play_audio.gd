extends Statement
class_name PlayAudio

func _init() -> void:
	type = 9 # Rakugo.StatementType.PLAY_AUDIO
	parameters_names = ["node_id", "from_pos"]
	parameters["node_id"] = ""
	parameters["from_pos"] = 0.0

func exec() -> void:
	.exec()
	Rakugo.on_play_audio(parameters.node_id, parameters.from_pos)