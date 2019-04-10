extends Object
class_name LoadGlobalHistory 

static func invoke() -> bool:
	var save_name = "global_history"
	
	Rakugo.loading_in_progress = true

	var save_folder = Rakugo.save_folder
	var save_folder_path = "usr://".plus_file(save_folder)
	
	if Rakugo.test_save:
		save_folder_path = "res://".plus_file(save_folder)

	var save_path = save_folder_path.plus_file(save_name)
	
	if Rakugo.test_save:
		save_path += ".tres"
		
	else:
		save_path += ".res"

	Rakugo.debug(["load global history from:", save_name])
	
	var file:= File.new()
	
	if not file.file_exists(save_path):
		print("global history file %s doesn't exist" % save_path)
		Rakugo.loading_in_progress = false
		return false
	
	var save_hist : HistorySave = load(save_path)
	Rakugo.global_history = save_hist.history_data

	Rakugo.loading_in_progress = false
		
	return true