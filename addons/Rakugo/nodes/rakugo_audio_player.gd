extends AudioStreamPlayer
class_name RakugoAudioPlayer

export var auto_define : = true
export var node_id : = ""

func _ready() -> void:
	Rakugo.connect("play_audio", self, "_on_play")
	Rakugo.connect("stop_audio", self, "_on_stop")

	if node_id.empty():
		node_id = name

	if auto_define:
		Rakugo.node_link(node_id, get_path())

func _on_play(id : String, from_pos : = 0.0) -> void:
	if id != node_id:
		return

	play(from_pos)

func _on_stop(id : String) -> void:
	if id != node_id:
		return

	if not is_playing():
		return
	
	stop()

