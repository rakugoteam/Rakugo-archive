extends Node

var thread = null


func invoke(scene_id, force_reload = true):
	get_tree().paused = true

	var scene_links = load(Rakugo.scene_links).get_as_dict()
	if scene_id in scene_links:
		push_error("Scene '"+scene_id+"' not found in linker")
	
	if force_reload or Rakugo.current_scene != scene_id:
		Rakugo.clean_dialogs()
		
		var path = scene_links[scene_id].resource_path
		thread = Thread.new()
		thread.start( self, "_thread_load", path)
	
		Rakugo.current_scene = scene_id
		
		yield(Rakugo, "scene_loaded")

	get_tree().paused = false

func _thread_load(path):
	var ril = ResourceLoader.load_interactive(path)
	assert(ril)
	Rakugo.call_deferred('emit_signal', 'load_scene', ril)

	var res = null

	while not res:
		#OS.delay_msec(SIMULATED_DELAY_SEC * 1000.0)

		var err = ril.poll()
		Rakugo.call_deferred('emit_signal', 'loading_scene')
		res = ril.get_resource()

		if not res and err != OK:
			push_error("There was an error loading")
			break

	call_deferred("_thread_done", res)


func _thread_done(resource):
	assert(resource)

	thread.wait_to_finish()

	# Instantiate new scene
	var new_scene = resource.instance()
	# Free current scene
	Rakugo.viewport.remove_child(Rakugo.current_scene_node)

	Rakugo.viewport.add_child(new_scene)
	Rakugo.current_scene_node = new_scene

	Rakugo.emit_signal("scene_loaded")
