extends Node


func invoke(scene_id: String, dialogue_name: String, event_name: String, force_reload := false) -> void:
	Rakugo.load_scene(scene_id, force_reload)
	yield(Rakugo, "started")

	Rakugo.debug(["jump to scene:", Rakugo.current_scene, "with dialog:", Rakugo.current_dialogue_name, "from:", Rakugo.story_state])

	if Rakugo.started:
		var dialogue_node = get_dialogue(Rakugo.current_scene_node, dialogue_name)
		if dialogue_node:
			dialogue_node.start(event_name)

func get_dialogue(node, dialogue_name):
	if node.name == dialogue_name:
		return node

	for c in node.get_children():
		var out = get_dialogue(c, dialogue_name)
		if out:
			return out

	return null
