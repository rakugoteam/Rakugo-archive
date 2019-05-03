extends Object

func invoke() -> bool:
	var r = Rakugo
	var save_name = "global_history"
	var new_save := HistorySave.new()
	new_save.game_version = r.game_version
	new_save.rakugo_version = r.rakugo_version
	new_save.history_data = r.global_history.duplicate()

	var dir := Directory.new()

	var save_folder = r.save_folder

	var save_folder_path = "usr://".plus_file(save_folder)

	if r.test_save:
		save_folder_path = "res://".plus_file(save_folder)

	if not dir.dir_exists(save_folder):
		dir.make_dir_recursive(save_folder_path)

	var save_path = save_folder.plus_file(save_name)

	if r.test_save:
		save_path += ".tres"

	else:
		save_path += ".res"

	var error := ResourceSaver.save(save_path, new_save)
	r.debug(["save global history to:", save_name])

	if error != OK:
		print("There was issue writing global history %s to %s" % [save_name, save_path])
		return false

	return  true
