extends AnimationPlayer

export(String) var node_id = "NewAnimPlayer"

func _ready():
	Ren.node_link(self, node_id)
	Ren.connect("play_anim", self, "_on_play")

func _on_play(id, anim_name, exit_statement = true):
	if id != node_id:
		return
	
	if exit_statement:
		if not is_connected("animation_finished", Ren, "exit_statement"):
			connect("animation_finished", Ren, "exit_statement")
	
	elif is_connected("animation_finished", Ren, "exit_statement"):
		disconnect("animation_finished", Ren, "exit_statement")
			
	play(anim_name)

