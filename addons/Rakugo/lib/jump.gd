extends Node


func invoke(scene_id: String, dialogue_name: String, event_name: String, force_reload := false) -> void:
	Rakugo.exit_dialogue()
	if Rakugo.load_scene(scene_id, force_reload):
		yield(Rakugo.SceneLoader, "scene_loaded")

	var dialogue_node
	if dialogue_name:
		dialogue_node = get_dialogue(get_tree().current_scene, dialogue_name)
	else:
		dialogue_node = get_first_dialogue(get_tree().current_scene)
	
	if dialogue_node:
		if event_name:
			dialogue_node.start(event_name)
		else:
			dialogue_node.start()


func get_dialogue(node, dialogue_name):
	if node.name == dialogue_name and node is Dialogue:
		return node

	for c in node.get_children():
		var out = get_dialogue(c, dialogue_name)
		if out:
			return out

	return null


func get_first_dialogue(node):
	if node is Dialogue:
		return node

	for c in node.get_children():
		var out = get_first_dialogue(c)
		if out:
			return out

	return null
