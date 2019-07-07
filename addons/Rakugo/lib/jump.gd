extends Node

func invoke(
		id_of_scene:String,
		node_name:String,
		dialog_name:String,
		state := 0,
		force_reload := false
	) ->void :

	var r = Rakugo
	var scenes_links = load(r.scenes_links).get_as_dict()
	var path = r.current_scene
	r.current_node_name = node_name
	r.current_dialog_name = dialog_name
	r.story_state = state
	r.current_scene = id_of_scene

	r.debug(["jump to scene:", r.current_scene, "with dialog:", dialog_name, "from:", r.story_state])

	if scenes_links.has(id_of_scene):
		path = scenes_links[id_of_scene].resource_path

	if (r.current_scene_path != path) or force_reload:
		r.current_scene = path

		if r.current_root_node != null:
			r.current_root_node.queue_free()

		var lscene = load(path)
		r.current_root_node = lscene.instance()
		get_tree().get_root().add_child(r.current_root_node)
		r.started = true
		r.emit_signal("started")

	if r.started:
		r.story_step()
