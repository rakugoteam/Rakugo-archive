extends AnimationPlayer

export(bool) var auto_define = true
export(String) var node_id = "NewAnimPlayer"

var reset_anim = true
var exit_count = 0

func _ready():
	Ren.connect("play_anim", self, "_on_play")
	Ren.connect("exit_statement", self, "_on_exit")
	
	if node_id.empty():
		node_id = name

	if auto_define:
		Ren.node_link(self, node_id)

func _on_play(id, anim_name, reset):
	if id != node_id:
		return
	
	reset_anim = reset
	
	play(anim_name)

func _on_exit(prev_type, kwargs):
	if not is_playing():
		return
		
	exit_count += 1
	if exit_count > 1:
		stop(reset_anim)
		exit_count = 0
