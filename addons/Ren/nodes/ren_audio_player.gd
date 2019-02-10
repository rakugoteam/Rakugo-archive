extends AudioStreamPlayer
class_name RenAudioPlayer

export var auto_define : = false
export var node_id : = ""

func _ready() -> void:
	Ren.connect("play_audio", self, "_on_play")
	Ren.connect("stop_audio", self, "_on_stop")

	if node_id.empty():
		node_id = name

	if auto_define:
		Ren.node_link(self, node_id)

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

