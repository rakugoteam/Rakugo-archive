extends AnimationPlayer
class_name RenAnimPlayer

export var auto_define : = false
export var node_id : = ""

func _ready() -> void:
	Ren.connect("play_anim", self, "_on_play")
	Ren.connect("stop_anim", self, "_on_stop")
	
	if node_id.empty():
		node_id = name

	if auto_define:
		Ren.node_link(self, node_id)

func _on_play(id : String, anim_name : String) -> void:
	if id != node_id:
		return
	
	play(anim_name)

func _on_stop(id : String, reset : bool) -> void:
	if id != node_id:
		return

	if not is_playing():
		return
	
	stop(false)
	
	## walkaround stop(true) don't reset animation
	if reset:
		seek(0, true)

