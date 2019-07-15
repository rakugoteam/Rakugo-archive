extends Object

func invoke() -> bool:
	var r = Rakugo
	var save_name = "global_history"
	r.loading_in_progress = true

	var save_folder = r.save_folder
	var save_folder_path = "usr://".plus_file(save_folder)

	if r.test_save:
		save_folder_path = "res://".plus_file(save_folder)

	var save_path = save_folder_path.plus_file(save_name)

	if r.test_save:
		save_path += ".tres"

	else:
		save_path += ".res"

	r.debug(["load global history from: %s" %save_name])

	var file := File.new()

	if not file.file_exists(save_path):
		push_error("global history file %s doesn't exist" %save_path)
		r.loading_in_progress = false
		return false

	var save_hist: HistorySave = load(save_path)
	r.global_history = save_hist.history_data

	r.loading_in_progress = false

	return true
