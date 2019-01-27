extends Statement
class_name PlayAudio

func _init() -> void:
	type = 9 # Ren.StatementType.PLAY_AUDIO
	kws = ["node_id", "from_pos"]
	kwargs["node_id"] = ""
	kwargs["from_pos"] = 0.0

func exec(dbg : bool = true) -> void:
	.exec(dbg)
	Ren.on_play_audio(kwargs.node_id, kwargs.from_pos)