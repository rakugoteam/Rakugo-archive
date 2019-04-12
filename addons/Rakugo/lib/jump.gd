extends Node

func invoke(
		path_to_current_scene:String, 
		node_name:String, 
		dialog_name:String,
		change := true
	) ->void :
	
	var r = Rakugo
	r.current_node_name = node_name
	r.current_dialog_name = dialog_name
	
	r.current_scene = r.scenes_dir + "/" + path_to_current_scene + ".tscn"
	
	if path_to_current_scene.ends_with(".tscn"):
		r.current_scene = path_to_current_scene
	
	r.debug(["jump to scene:", r.current_scene, "with dialog:", dialog_name, "from:", r.story_state])

	if change:
		if r.current_root_node != null:
			r.current_root_node.queue_free()
		
		var lscene = load(r.current_scene)
		r.current_root_node = lscene.instance()
		get_tree().get_root().add_child(r.current_root_node)

		emit_signal("started")
	
	if r.started:
		r.story_step()
