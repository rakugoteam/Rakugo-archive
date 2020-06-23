tool
extends AnimationPlayer
class_name RakugoAnimPlayer, "res://addons/Rakugo/icons/rakugo_animation_player.svg"

export var node_id : String = name setget _set_node_id, _get_node_id
export var saveable := true setget _set_saveable, _get_saveable

var rnode := RakugoNodeCore.new()
var _node_id := ""
var _saveable := true
var node_link: NodeLink

func _ready() -> void:
	_set_saveable(_saveable)

	if _node_id.empty():
		_node_id = name

	if Engine.editor_hint:
		return

	Rakugo.connect("play_anim", self, "_on_play")
	Rakugo.connect("stop_anim", self, "_on_stop")

	node_link = Rakugo.get_node_link(_node_id)

	if  not node_link:
		node_link = Rakugo.node_link(_node_id, get_path())


func _set_node_id(value: String):
	_node_id = value


func _get_node_id() -> String:
	if _node_id == "":
		_node_id = name

	return _node_id


func _set_saveable(value: bool):
	_saveable = value
	rnode.make_saveable(self, value)


func _get_saveable() -> bool:
	return _saveable


func _on_play(id: String, anim_name: String) -> void:
	if id != _node_id:
		return

	play(anim_name)


func _on_stop(id: String, reset: bool) -> void:
	if id != _node_id:
		return

	if not is_playing():
		return

	stop(false)

	# walkaround stop(true) don't reset animation
	if reset:
		seek(0, true)


func on_save():
	if not node_link:
		push_error("error with saving: %s"  %_node_id)
		return

	node_link.value["anim_name"] = current_animation
	node_link.value["is_playing"] = is_playing()


func on_load(game_version: String) -> void:
	if not node_link:
		push_error("error with loading: %s" %_node_id)
		return

	if "is_playing" in node_link.value:
		if node_link.value["is_playing"]:
			if "anim_name" in node_link.value:
				var anim_name = node_link.value["anim_name"]
				_on_play(node_id, anim_name)

