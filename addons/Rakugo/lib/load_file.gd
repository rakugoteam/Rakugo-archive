extends Object
class_name LoadFile

static func invoke(save_folder: String, save_name: String,  variables: Dictionary):
	Rakugo.loading_in_progress = true

	var save_folder_path = "usr://".plus_file(save_folder)
	
	if Rakugo.test_save:
		save_folder_path = "res://".plus_file(save_folder)

	var save_file_path = save_folder_path.plus_file(save_name)
	Rakugo.debug(["load data from:", save_name])
	
	var file:= File.new()
	
	if Rakugo.test_save:
		save_file_path += ".tres"

	if not file.file_exists(save_file_path):
		print("Save file %s doesn't exist" % save_file_path)
		return false
	
	var save : Resource = load(save_file_path)
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

			_:
				Rakugo.define(k, v.value)
			
	for q_id in Rakugo.quests:
		var q = Rakugo.get_quest(q_id)
		q.update_subquests()
		
	for node in Rakugo.get_tree().get_nodes_in_group("save"):
		node.on_load(game_version)

	Rakugo.history_id = save.history_id

	Rakugo.start(true)
	
	Rakugo.loading_in_progress = false
	
	Rakugo.jump(
		save.scene,
		save.node_name,
		save.dialog_name,
		true
		)
	
	return true