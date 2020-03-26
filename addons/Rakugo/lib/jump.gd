extends Node

func invoke(
		scene_id: String,
		node_name: String,
		dialog_name: String,
		state := 0,
		force_reload := false
		) -> void:

	var r = Rakugo
	r.current_node_name = node_name
	r.current_dialog_name = dialog_name
	r.story_state = state

	r.debug(["jump to scene:", r.current_scene, "with dialog:", dialog_name, "from:", r.story_state])

	load_scene(scene_id, force_reload)

	if r.started:
		r.story_step()


func load_scene(scene_id, force_reload := true):
	var r = Rakugo
	var scenes_links = load(r.scenes_links).get_as_dict()
	var path = r.current_scene
	r.current_scene = scene_id

	if scene_id in scenes_links:

		var p = scenes_links[scene_id]

		if p is PackedScene:
			path = p.resource_path

		else:
			path = p

	if (r.current_scene_path != path) or force_reload:
		r.current_scene = path

		if r.current_root_node != null:
			r.current_root_node.queue_free()

		var lscene = load(path)
		r.current_root_node = lscene.instance()
		r.viewport.add_child(r.current_root_node)

		r.started = true
		r.emit_signal("started")
