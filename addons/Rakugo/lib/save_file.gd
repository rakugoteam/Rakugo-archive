extends Object
class_name SaveFile

static func invoke(
	save_folder: String, save_name: String, 
	game_version: String , rakugo_version: String, 
	history: Array, current_scene: String, current_node_name: String,
	current_dialog_name: String, variables: Dictionary
	) -> bool:
		
	var new_save = Save.new()
	new_save.game_version = game_version
	new_save.rakugo_version = rakugo_version
	new_save.history = history.duplicate()
	new_save.scene = current_scene
	new_save.node_name = current_node_name
	new_save.dialog_name = current_dialog_name
	
	for node in Rakugo.get_tree().get_nodes_in_group("save"):
		node.on_save()
	
	for v in variables.values():
		v.save_to(new_save.data)
		
	var dir := Directory.new()
	if not dir.dir_exists(save_folder):
		dir.make_dir_recursive(save_folder)
		
	var save_path = save_folder.plus_file(save_name)
	var  error := ResourceSaver.save(save_path, new_save)
	
	if error != OK:
		print("There was issue writing save %s to %s" % [save_name, save_path])
		return false
		
	return  true