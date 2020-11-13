extends Node

var store_stack = []
var store_stack_max_length = 5
var current_store_id = 0
var persistent_store = null


var save_folder_path = ""

func init():
	self.init_save_folder()
	self.init_persistent_store()
	self.init_store_stack()

func init_save_folder():
	save_folder_path = Settings.get("rakugo/saves/save_folder")
	if not Settings.get("rakugo/saves/test_mode"):
		save_folder_path = save_folder_path.replace("res://", "user://")
	Directory.new().make_dir_recursive(save_folder_path)
	save_folder_path = save_folder_path.trim_suffix("/") + "/"

func get_save_folder_path():
	if not save_folder_path:
		init_save_folder()
	return save_folder_path


func get_save_path(save_name, no_ext=false):
	save_name = save_name.replace('.tres', '')
	save_name = save_name.replace('.res', '')
	var savefile_path = save_folder_path.plus_file(save_name)
	if not no_ext:
		if Settings.get('rakugo/saves/test_mode'):
			savefile_path += ".tres"
		else:
			savefile_path += ".res"
	return savefile_path


func get_save_name(save_name):
	save_name = save_name.split('/', false)
	save_name = save_name[save_name.size()-1]
	save_name = save_name.replace('.tres', '')
	save_name = save_name.replace('.res', '')
	return save_name


### Store lifecycle

func call_for_restoring():
	get_tree().get_root().propagate_call('_restore', [get_current_store()])

func call_for_storing():
	get_tree().get_root().propagate_call('_store', [get_current_store()])


func get_current_store():
	return store_stack[current_store_id]


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



### Store Stack

func init_store_stack():
	var new_save := Store.new()
	new_save.game_version = Rakugo.game_version
	new_save.rakugo_version = Rakugo.rakugo_version
	new_save.scene = Rakugo.current_scene_name
	new_save.history = []
	store_stack = [new_save]


func prune_front_stack():
	if current_store_id:
		store_stack = store_stack.slice(current_store_id, store_stack.size() - 1)
		current_store_id = 0


func prune_back_stack():
	store_stack = store_stack.slice(0, store_stack_max_length - 1)


func save_store_stack(save_name: String) -> bool:
	call_for_storing()
	
	var packed_stack = StoreStack.new()
	packed_stack.stack = self.store_stack
	packed_stack.current_id = self.current_store_id

	var savefile_path = self.get_save_path(save_name)

	var error := ResourceSaver.save(savefile_path, packed_stack)

	if error != OK:
		print("There was issue writing save %s to %s error_number: %s" % [save_name, savefile_path, error])
		return false

	return  true


func load_store_stack(save_name: String):
	Rakugo.loading_in_progress = true
	Rakugo.debug(["load data from:", save_name])

	var file := File.new()

	var savefile_path = self.get_save_path(save_name)

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



### Persistent store

func get_persistent_store():
	return persistent_store

func init_persistent_store():
	var file = File.new()
	var persistent_path = save_folder_path + "persistent.tres"
	if file.file_exists(persistent_path):
		persistent_store = load(persistent_path)
	else:
		persistent_store = Store.new()
	persistent_store.game_version = Rakugo.game_version
	persistent_store.rakugo_version = Rakugo.rakugo_version

func save_persistent_store():
	var error = ResourceSaver.save(save_folder_path + "persistent.tres", persistent_store)
	if error != OK:
		print("Error writing persistent store %s to %s error_number: %s" % ["persistent.tres", save_folder_path, error])

