extends Node

var store_stack = []
var store_stack_max_length = 5
var current_store_id = 0


var save_folder_path

func init():
	if Rakugo.test_save:
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
	new_save.history = Rakugo.history.duplicate()
	new_save.scene = Rakugo.current_scene_name
	store_stack = [new_save]

func call_for_restoring():
	for node in Rakugo.get_tree().get_nodes_in_group("save"):
		if node.has_method("on_load"):
			node.on_load(Rakugo.game_version)
			continue
	for s in store_stack.size():
		print(s, "  ", store_stack[s],  "  ", store_stack[s].current_dialogue_event_stack)
	get_tree().get_root().propagate_call('_restore', [get_current_store().duplicate(true)])


func call_for_storing():
	for node in Rakugo.get_tree().get_nodes_in_group("save"):
		if node.has_method("on_save"):
			node.on_save()
			continue
	
	get_tree().get_root().propagate_call('_store', [get_current_store()])
	
	for v in Rakugo.variables.values():
		v.save_to(get_current_store().data)

func prune_front_stack():
	if current_store_id:
		store_stack = store_stack.slice(current_store_id, store_stack.size() - 1)
		current_store_id = 0

func prune_back_stack():
	store_stack = store_stack.slice(0, store_stack_max_length - 1)


func stack_next_store():
	self.call_for_storing()
	self.prune_front_stack()
	
	var previous_store = (store_stack[0] as Resource).duplicate(true)
	previous_store.replace_connections(store_stack[0])
	store_stack.insert(1, previous_store)
	
	self.prune_back_stack()


func change_current_stack_index(index):
	index = clamp(index, 0, store_stack.size()-1)
	store_stack[current_store_id].replace_connections(store_stack[index])
	current_store_id = index
	
	call_for_restoring()


func get_savefile_path(savefile_name):
	var savefile_path = save_folder_path.plus_file(savefile_name)

	if Rakugo.test_save:
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



func unpack_data(path:String) -> Resource:
	var packed_stack:StoreStack = load(path) as StoreStack

	packed_stack = packed_stack.duplicate()
	
	self.store_stack = []
	for s in packed_stack.stack:
		self.store_stack.append(s.duplicate(true))
	self.current_store_id = packed_stack.current_id

	var save = get_current_store()
	var game_version = save.game_version

	Rakugo.quests.clear()
	Rakugo.history = save.history.duplicate()

	for i in range(save.data.size()):
		var k = save.data.keys()[i]
		var v = save.data.values()[i]

		Rakugo.debug([k, v])

		match v.type:
			Rakugo.Type.CHARACTER:
				Rakugo.character(k, v.value)

			Rakugo.Type.SUBQUEST:
				Rakugo.subquest(k, v.value)

			Rakugo.Type.QUEST:
				Rakugo.quest(k, v.value)

				if k in Rakugo.quests:
					continue

				Rakugo.quests.append(k)

			Rakugo.Type.NODE:
				var n = NodeLink.new(k)
				n.load_from(v.value)
				Rakugo.variables[k] = n

			_:
				Rakugo.define(k, v.value)

	for q_id in Rakugo.quests:
		var q = Rakugo.get_var(q_id)
		q.update_subquests()
	
	return save
