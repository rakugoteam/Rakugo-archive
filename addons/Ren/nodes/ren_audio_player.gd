extends AudioStreamPlayer
class_name RenAudioPlayer

export(bool) var auto_define = false
export(String) var node_id = ""

func _ready():
	Ren.connect("play_audio", self, "_on_play")
	Ren.connect("stop_audio", self, "_on_stop")

	if node_id.empty():
		node_id = name

	if auto_define:
		Ren.node_link(self, node_id)

func _on_play(id, from_pos = 0.0):
	if id != node_id:
		return

	play(from_pos)

func _on_stop(id):
	if id != node_id:
		return

	if not is_playing():
		return
	
	stop()

