extends Node

onready var r = Rakugo

func invoke(
		scene_id: String,
		node_name: String,
		dialog_name: String,
		state := 0,
		force_reload := false
		) -> void:

	r.current_node_name = node_name
	r.current_dialog_name = dialog_name
	r.story_state = state

	if load_scene(scene_id, force_reload):
		yield(r, "started")

	r.debug(["jump to scene:", r.current_scene, "with dialog:", dialog_name, "from:", r.story_state])

	if r.started:
		r.story_step()


func load_scene(scene_id, force_reload := true) -> bool:
	var changed_scene = false

	get_tree().paused = true
	var scenes_links = load(r.scenes_links).get_as_dict()
	var path = r.current_scene
	r.current_scene = scene_id

	if scene_id in scenes_links:

		var p = scenes_links[scene_id]

		if p is PackedScene:
			path = p.resource_path

		else:
			path = p

	if (
		(r.current_scene_path != path)
		or force_reload
		):

		r.clean_dialogs()

		if r.story_state > 0:
			r.story_state -= 1

		r.current_scene = path
		r.loading_screen.load_scene(path)
		yield(r.loading_screen, "loaded")
		changed_scene = true

	get_tree().paused = false
	r.started = true
	r.emit_signal("started")
	return changed_scene
