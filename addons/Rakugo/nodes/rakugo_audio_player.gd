tool
extends AudioStreamPlayer
class_name RakugoAudioPlayer, "res://addons/Rakugo/icons/rakugo_audio_player.svg"

export var node_id : String = name setget _set_node_id, _get_node_id
export var saveable := true setget _set_saveable, _get_saveable

var rnode := RakugoNodeCore.new()
var node_link: NodeLink
var last_pos := 0.0
var _node_id := ""
var _saveable := true

func _ready() -> void:
	_set_saveable(_saveable)

	if _node_id.empty():
		_node_id = name

	if Engine.editor_hint:
		return

	Rakugo.connect("play_audio", self, "_on_play")
	Rakugo.connect("stop_audio", self, "_on_stop")

	node_link = Rakugo.get_node_link(_node_id)

	if not node_link:
		node_link = Rakugo.node_link(_node_id, get_path())


func _set_node_id(value: String):
	_node_id = value


func _get_node_id() -> String:
	if _node_id == "":
		_node_id = name

	return _node_id


func _set_saveable(value: bool):
	_saveable = value

	if not rnode:
		rnode = RakugoNodeCore.new()

	rnode.make_saveable(self, value)


func _get_saveable() -> bool:
	return _saveable


func _on_play(id: String, from_pos := 0.0) -> void:
	if id != _node_id:
		return

	last_pos = from_pos
	play(from_pos)


func _on_stop(id: String) -> void:
	if id != _node_id:
		return

	if not is_playing():
		return

	stop()


func on_save():
	if not node_link:
		if _node_id != "":
			push_error("error with saveing: %s" % _node_id)
		else:
			push_error("error with saveing: %s it propably it don't have id" % name)
		return

	node_link.value["is_playing"] = is_playing()
	node_link.value["from_pos"] = last_pos


func on_load(game_version: String) -> void:
	if not node_link:
		if _node_id != "":
			push_error("error with loading: %s" %_node_id)
		else:
			push_error("error with loading: %s it propably it don't have id" %name)
		return

	if "is_playing" in node_link:
		if node_link.value["is_playing"]:
			var last_pos = node_link.value["from_pos"]
			_on_play(_node_id, last_pos)

	else:
		_on_stop(_node_id)


func _exit_tree() -> void:
	if Engine.editor_hint:
		return

	Rakugo.variables.erase(_node_id)
