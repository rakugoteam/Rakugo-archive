extends AnimationPlayer

export(String) var node_id = "NewAnimPlayer"

func _ready():
	Ren.node_link(self, node_id)
	Ren.connect("play_anim", self, "_on_play")

func _on_play(id, anim_name):
	if id != node_id:
		return
	
	play(anim_name)

