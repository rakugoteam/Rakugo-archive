tool
extends Spatial
class_name RakugoSpatial, "res://addons/Rakugo/icons/rakugo_spatial.svg"

signal on_substate(substate)

var rnode := RakugoNodeCore.new()

export var node_id := "" setget _set_node_id, _get_node_id
export var saveable := true setget _set_saveable, _get_saveable
export (Array, String) var state: Array setget _set_state, _get_state

var _node_id := ""
var _saveable := true
var _state: Array
var node_link: NodeLink
var last_show_args: Dictionary

func _ready() -> void:
	_set_saveable(_saveable)

	if _node_id.empty():
		_node_id = name

	if Engine.editor_hint:
		return

	Rakugo.connect("show", self, "_on_show")
	Rakugo.connect("hide", self, "_on_hide")
	rnode.connect("on_substate", self, "_on_rnode_substate")

	node_link = Rakugo.get_node_link(_node_id)

	if not node_link:
		node_link = Rakugo.node_link(_node_id, get_path())

	else:
		node_link.node_path = get_path()


func _on_rnode_substate(substate):
	emit_signal("on_substate", substate)

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


func _on_show(id: String, state_value: Array, show_args: Dictionary) -> void:
	if _node_id != id:
		return

	var def_pos = Vector2(translation.x , translation.y)
	var pos = rnode.show_at(show_args, def_pos)

	var z = translation.z

	if z in show_args:
		z = show_args.z

	translation = Vector3(pos.x, pos.y, z)

	_set_state(state_value)

	if not self.visible:
		show()


func _set_state(value: Array) -> void:
	_state = value

	if not value:
		return

	if not rnode:
		return

	_state = rnode.setup_state(value)


func _get_state() -> Array:
	return _state


func _on_hide(id: String) -> void:
	if _node_id != id:
		return

	hide()


func on_save() -> void:
	rnode.save_visible_node(node_link, self)


func on_load(game_version: String) -> void:
	rnode.load_visible_node(node_link, self)


func _on_substate(substate):
	pass
