extends AnimationPlayer

export(bool) var auto_define = false
export(String) var node_id = ""

func _ready():
	Ren.connect("play_anim", self, "_on_play")
	Ren.connect("stop_anim", self, "_on_stop")
	
	if node_id.empty():
		node_id = name

	if auto_define:
		Ren.node_link(self, node_id)

func _on_play(id, anim_name):
	if id != node_id:
		return
	
	play(anim_name)

func _on_stop(id, reset):
	if id != node_id:
		return

	if not is_playing():
		return
	
	stop(false)
	
	if reset:
		seek(0, true)

