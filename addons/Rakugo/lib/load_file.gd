extends Object

func invoke(save_folder: String, save_name: String,  variables: Dictionary):
	var r = Rakugo
	r.loading_in_progress = true

	var save_folder_path = "usr://".plus_file(save_folder)

	if r.test_save:
		save_folder_path = "res://".plus_file(save_folder)

	var save_file_path = save_folder_path.plus_file(save_name)
	r.debug(["load data from:", save_name])

	var file := File.new()

	if r.test_save:
		save_file_path += ".tres"

	else:
		save_file_path += ".res"

	if not file.file_exists(save_file_path):
		push_error("Save file %s doesn't exist" % save_file_path)
		r.loading_in_progress = false
		return false

	var save: Resource = load(save_file_path)

	var game_version = save.game_version

	r.quests.clear()
	r.history = save.history.duplicate()

	for i in range(save.data.size()):
		var k = save.data.keys()[i]
		var v = save.data.values()[i]

		r.debug([k, v])

		match v.type:
			r.Type.CHARACTER:
				r.character(k, v.value)

			r.Type.SUBQUEST:
				r.subquest(k, v.value)

			r.Type.QUEST:
				r.quest(k, v.value)

				if k in r.quests:
					continue

				r.quests.append(k)

			r.Type.NODE:
				var n = NodeLink.new(k)
				n.load_from(v.value)
				r.variables[k] = n

			_:
				r.define(k, v.value)

	for q_id in r.quests:
		var q = r.get_var(q_id)
		q.update_subquests()

	r.start(true)

	var story_state = save.story_state

	if story_state > 0:
		story_state -= 1

	r.jump(
		save.scene,
		save.node_name,
		save.dialog_name,
		story_state,
		true
		)

	for node in r.get_tree().get_nodes_in_group("save"):
		if node.has_method("on_load"):
			node.on_load(r.game_version)
			continue

		# to fix bug
		var rc = node as RakugoControl

		if rc:
			if rc.register:
				rc.on_load()

	r.loading_in_progress = false
	return true
