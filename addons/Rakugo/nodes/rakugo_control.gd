tool
extends RakugoBaseControl
class_name RakugoControl, "res://addons/Rakugo/icons/rakugo_control.svg"

signal on_substate(substate)

onready var rnode := RakugoNodeCore.new()

export var node_id : String = name setget _set_node_id, _get_node_id
export var saveable := true setget _set_saveable, _get_saveable
export (Array, String) var state: Array setget _set_state, _get_state

var _state: Array
var node_link: NodeLink
var last_show_args: Dictionary
var _node_id := ""
var _saveable := true

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
		node_link.value["node_path"] = get_path()


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
	rnode.make_saveable(value, self)
  

func _get_saveable() -> bool:
	return _saveable


func _on_show(id: String , state_value: Array, show_args: Dictionary) -> void:
	if _node_id != id:
		return

	rect_position = rnode.show_at(show_args, rect_position)

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
	rnode.load_visible_node(self)
  

func _on_substate(substate):
	pass
