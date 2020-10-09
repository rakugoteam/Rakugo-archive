extends Node

var store_stack = []
var store_stack_max_length = 5
var current_store_id = 0


var save_folder_path

func init():
	if Settings.get('rakugo/saves/test_mode'):
		save_folder_path = "res://".plus_file(Rakugo.save_folder)
	else:
		save_folder_path = "user://".plus_file(Rakugo.save_folder)
		
	self.init_store_stack()


func get_current_store():
	return store_stack[current_store_id]

func init_store_stack():
	var new_save := Store.new()
	new_save.game_version = Rakugo.game_version
	new_save.rakugo_version = Rakugo.rakugo_version
	new_save.scene = Rakugo.current_scene_name
	new_save.history = []
	store_stack = [new_save]

func call_for_restoring():
	get_tree().get_root().propagate_call('_restore', [get_current_store()])


func call_for_storing():
	get_tree().get_root().propagate_call('_store', [get_current_store()])

func prune_front_stack():
	if current_store_id:
		store_stack = store_stack.slice(current_store_id, store_stack.size() - 1)
		current_store_id = 0

func prune_back_stack():
	store_stack = store_stack.slice(0, store_stack_max_length - 1)


func stack_next_store():
	self.call_for_storing()
	self.prune_front_stack()
	
	var previous_store = store_stack[0].duplicate()
	previous_store.replace_connections(store_stack[0])
	store_stack.insert(1, previous_store)
	
	self.prune_back_stack()


func change_current_stack_index(index):
	if current_store_id == 0:
		self.call_for_storing()
	index = clamp(index, 0, store_stack.size()-1)
	if index == current_store_id:
		return
	store_stack[current_store_id].replace_connections(store_stack[index])
	current_store_id = index
	
	self.call_for_restoring()


func get_savefile_path(savefile_name):
	var savefile_path = save_folder_path.plus_file(savefile_name)

	if Settings.get('rakugo/saves/test_mode'):
		savefile_path += ".tres"
	else:
		savefile_path += ".res"
	return savefile_path


func save_store_stack(save_name: String) -> bool:
	call_for_storing()
	
	var packed_stack = StoreStack.new()
	packed_stack.stack = self.store_stack
	packed_stack.current_id = self.current_store_id

	var savefile_path = self.get_savefile_path(save_name)

	var error := ResourceSaver.save(savefile_path, packed_stack)

	if error != OK:
		print("There was issue writing save %s to %s error_number: %s" % [save_name, savefile_path, error])
		return false

	return  true


func load_store_stack(save_name: String):
	Rakugo.loading_in_progress = true

	Rakugo.debug(["load data from:", save_name])

	var file := File.new()

	var savefile_path = self.get_savefile_path(save_name)

	if not file.file_exists(savefile_path):
		push_error("Save file %s doesn't exist" % savefile_path)
		Rakugo.loading_in_progress = false
		return false

	unpack_data(savefile_path)

	#Rakugo.start(true)
	#Rakugo.load_scene(get_current_store().scene)

	call_for_restoring()
	
	yield(Rakugo, "started")

	Rakugo.loading_in_progress = false
	return true



func unpack_data(path:String) -> Store:
	var packed_stack:StoreStack = load(path) as StoreStack

	packed_stack = packed_stack.duplicate()
	
	self.store_stack = []
	for s in packed_stack.stack:
		self.store_stack.append(s.duplicate())
	self.current_store_id = packed_stack.current_id

	var save = get_current_store()
	var game_version = save.game_version
	
	return save
