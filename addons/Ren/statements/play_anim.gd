extends "statement.gd"

func _init():
	type = "play_anim"
	kws = ["node_id", "anim_name"]

func exec(dbg = true):
	kwargs["add_to_history"] = false
	.exec(dbg)
	Ren.play_anim(kwargs.node_id, kwargs.anim_name)

func on_exit(_type, new_kwargs = {}):
	Ren.story_step()


