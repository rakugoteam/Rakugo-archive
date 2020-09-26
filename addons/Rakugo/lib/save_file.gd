extends Node


func invoke(save_name: String) -> bool:
	var new_save := Store.new()
	new_save.game_version = Rakugo.game_version
	new_save.rakugo_version = Rakugo.rakugo_version
	new_save.history = Rakugo.history.duplicate()
	new_save.scene = Rakugo.current_scene_name

	var save_folder_path = "user://".plus_file(Rakugo.save_folder)

	if Rakugo.test_save:
		save_folder_path = "res://".plus_file(Rakugo.save_folder)

	for node in Rakugo.get_tree().get_nodes_in_group("save"):
		if node.has_method("on_save"):
			node.on_save()
			continue
	
	get_tree().get_root().propagate_call('_store', [new_save])

	for v in Rakugo.variables.values():
		v.save_to(new_save.data)

	var dir := Directory.new()

	if not dir.dir_exists(save_folder_path):
		dir.make_dir_recursive(save_folder_path)

	var save_path = save_folder_path.plus_file(save_name)

	if Rakugo.test_save:
		save_path += ".tres"

	else:
		save_path += ".res"

	var error := ResourceSaver.save(save_path, new_save)

	if error != OK:
		print("There was issue writing save %s to %s error_number: %s" %
				[save_name, save_path, error])
		return false

	return  true
