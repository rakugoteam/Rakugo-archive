extends Object

func invoke(save_name: String) -> bool:
	var r = Rakugo
	var new_save = Save.new()
	new_save.game_version = r.game_version
	new_save.rakugo_version = r.rakugo_version
	new_save.history = r.history.duplicate()
	new_save.scene = r.current_scene
	new_save.node_name = r.current_node_name
	new_save.dialog_name = r.current_dialog_name
	new_save.story_state = r.story_state

	var save_folder_path = "usr://".plus_file(r.save_folder)

	if r.test_save:
		save_folder_path = "res://".plus_file(r.save_folder)

	for node in r.get_tree().get_nodes_in_group("save"):
		if node.has_method("on_save"):
			node.on_save()
			continue

		# to fix bug
		var rc = node as RakugoControl

		if rc:
			if rc.register:
				rc.on_save()

	for v in r.variables.values():
		v.save_to(new_save.data)

	var dir := Directory.new()

	if not dir.dir_exists(save_folder_path):
		dir.make_dir_recursive(save_folder_path)

	var save_path = save_folder_path.plus_file(save_name)

	if r.test_save:
		save_path += ".tres"

	else:
		save_path += ".res"

	var error := ResourceSaver.save(save_path, new_save)

	if error != OK:
		print("There was issue writing save %s to %s" % [save_name, save_path])
		return false

	return  true
