tool
extends AudioStreamPlayer
class_name RakugoAudioPlayer

export var node_id : = ""

var node_link:NodeLink
var last_pos : = 0.0

func _ready() -> void:
	if(Engine.editor_hint):
		if node_id.empty():
			node_id = name

		add_to_group("save", true)
		return

	Rakugo.connect("play_audio", self, "_on_play")
	Rakugo.connect("stop_audio", self, "_on_stop")

	if node_id.empty():
		node_id = name

	node_link = Rakugo.get_node_link(node_id)

	if  not node_link:
		node_link = Rakugo.node_link(node_id, get_path())

	add_to_group("save", true)

func _on_play(id : String, from_pos : = 0.0) -> void:
	if id != node_id:
		return

	last_pos = from_pos
	play(from_pos)

func _on_stop(id : String) -> void:
	if id != node_id:
		return

	if not is_playing():
		return

	stop()

func on_save():
	node_link = Rakugo.get_node_link(node_id)
	node_link.value["is_playing"] = is_playing()
	node_link.value["from_pos"] = last_pos

func on_load(game_version:String) -> void:
	node_link =  Rakugo.get_node_link(node_id)
	
	if "is_playing" in node_link:
		if node_link.value["is_playing"]:
			var last_pos = node_link.value["from_pos"]
			_on_play(node_id, last_pos)

	else:
		_on_stop(node_id)

func _exit_tree() -> void:
	if(Engine.editor_hint):
		remove_from_group("save")
		return

	Rakugo.variables.erase(node_id)
