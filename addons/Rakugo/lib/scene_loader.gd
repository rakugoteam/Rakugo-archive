extends Node

var thread = null

onready var scene_links:Dictionary = {}
onready var current_scene:String = ''



signal load_scene(resource_interactive_loader)
signal loading_scene()
signal scene_loaded()

func _ready():
	scene_links = load(ProjectSettings.get_setting("application/rakugo/scene_links")).get_as_dict()
	current_scene = ProjectSettings.get_setting("application/run/main_scene")
	for k in scene_links.keys():
		if scene_links[k] == current_scene:
			current_scene = k

	Rakugo.current_scene_node = get_tree().current_scene

func _store(store):
	store.current_scene = current_scene
	
func _restore(store):
	load_scene(store.current_scene)

func load_scene(scene_id, force_reload = false):
	if thread and thread.is_active():
		return
	get_tree().paused = true

	if not scene_id in scene_links:
		push_error("Scene '"+scene_id+"' not found in linker")
	
	
	if force_reload or self.current_scene != scene_id:
		Rakugo.exit_dialogue()
		
		thread = Thread.new()
		thread.start( self, "_thread_load", self.scene_links[scene_id])
	
		#Rakugo.current_scene = scene_id
		self.current_scene = scene_id
		
		yield(self, "scene_loaded")
	
	get_tree().paused = false

func _thread_load(path):
	var ril = ResourceLoader.load_interactive(path)
	assert(ril)
	self.call_deferred('emit_signal', 'load_scene', ril)

	var res = null

	while not res:
		#OS.delay_msec(SIMULATED_DELAY_SEC * 1000.0)

		var err = ril.poll()
		self.call_deferred('emit_signal', 'loading_scene')
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
	Rakugo.ShowableManager.declare_showables(new_scene)
	
	# Free current scene
	Rakugo.clean_viewport()

	Rakugo.viewport.add_child(new_scene)
	Rakugo.current_scene_node = new_scene

	self.emit_signal("scene_loaded")
