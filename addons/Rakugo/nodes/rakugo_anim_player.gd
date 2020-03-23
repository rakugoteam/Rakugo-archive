tool
extends AnimationPlayer
class_name RakugoAnimPlayer, "res://addons/Rakugo/icons/rakugo_animation_player.svg"

export var node_id : String = name setget _set_node_id, _get_node_id
export var saveable := true setget _set_saveable, _get_saveable

var _node_id := ""
var _saveable := true
var node_link: NodeLink

func _ready() -> void:
	_set_saveable(_saveable)

	if Engine.editor_hint:
		if node_id.empty():
			node_id = name
		return

	Rakugo.connect("play_anim", self, "_on_play")
	Rakugo.connect("stop_anim", self, "_on_stop")

	if node_id.empty():
		node_id = name

	node_link = Rakugo.get_node_link(node_id)

	if  not node_link:
		node_link = Rakugo.node_link(node_id, get_path())


func _set_node_id(value: String):
	_node_id = value


func _get_node_id() -> String:
	if _node_id == "":
		_node_id = name

	return _node_id


func _set_saveable(value: bool):
	_saveable = value

	if _saveable:
		add_to_group("save", true)

	elif is_in_group("save"):
		remove_from_group("save")


func _get_saveable() -> bool:
	return _saveable


func _on_play(id: String, anim_name: String) -> void:
	if id != node_id:
		return

	play(anim_name)


func _on_stop(id: String, reset: bool) -> void:
	if id != node_id:
		return

	if not is_playing():
		return

	stop(false)

	## walkaround stop(true) don't reset animation
	if reset:
		seek(0, true)


func on_save():
	if not node_link:
		push_error("error with saving: %s"  %node_id)
		return

	node_link.value["anim_name"] = current_animation
	node_link.value["is_playing"] = is_playing()


func on_load(game_version: String) -> void:
	if not node_link:
		push_error("error with loading: %s" %node_id)
		return

	if "is_playing" in node_link.value:
		if node_link.value["is_playing"]:
			if "anim_name" in node_link.value:
				var anim_name = node_link.value["anim_name"]
				_on_play(node_id, anim_name)


func _exit_tree() -> void:
	if(Engine.editor_hint):
		return

	Rakugo.variables.erase(node_id)
