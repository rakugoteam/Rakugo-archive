extends Statement
class_name StopAudio

func _init():
	._init()
	type = 10 # Ren.StatementType.STOP_AUDIO
	kws = ["node_id"]
	kwargs["node_id"] = ""

func exec(dbg = true):
	.exec(dbg)
	Ren.on_stop_audio(kwargs.node_id)