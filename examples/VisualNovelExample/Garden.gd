extends GDScriptDialog


func garden(node_name, dialog_name):
	if not check_dialog(node_name, dialog_name, "garden"):
		return

	match get_story_state():
		0:
			show("alice", {"state":["happy"]})
			say({
				"who":"alice",
				"what":"Welcome in my Garden [player_name].",
				"kind":"left",
				"avatar_state":["happy"]
			})
