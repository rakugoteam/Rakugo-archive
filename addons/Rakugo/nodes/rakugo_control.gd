tool
extends RakugoBaseControl
class_name RakugoControl

onready var rnode := RakugoNodeCore.new()

export var register := true
export var node_id : String setget _set_node_id, _get_node_id
export var camera := NodePath("")
export (Array, String) var state : Array setget _set_state, _get_state

var _state : Array
var node_link: NodeLink
var last_show_args:Dictionary

var _node_id := ""

func _ready() -> void:
	if(Engine.editor_hint):
		add_to_group("save", register)
		return

	Rakugo.connect("show", self, "_on_show")
	Rakugo.connect("hide", self, "_on_hide")

	if not register:
		return

	if node_id.empty():
		node_id = name

	node_link = Rakugo.get_var(node_id)

	if not node_link:
		node_link = Rakugo.node_link(node_id, get_path())

	else:
		node_link.value["node_path"] = get_path()

	add_to_group("save", register)

func _set_node_id(value : String):
	_node_id = value

func _get_node_id() -> String:
	if _node_id == "":
		_node_id = name

	return _node_id

func _on_show(node_id : String , state_value : Array, show_args : Dictionary) -> void:
	if self.node_id != node_id:
		return

	rect_position = rnode.show_at(Vector2(0, 0), show_args, rect_position)

	_set_state(state_value)

	if not self.visible:
		show()

func _set_state(value : Array) -> void:
	_state = state

func _get_state() -> Array:
	return _state

func _on_hide(_node_id : String) -> void:
	if _node_id != node_id:
		return

	hide()

func _exit_tree() -> void:
	if(Engine.editor_hint):
		remove_from_group("save")
		return

	if register:
		Rakugo.variables.erase(node_id)

func on_save() -> void:
	if not register:
		return

	node_link.value["visible"] = visible
	node_link.value["state"] = _state
	node_link.value["show_args"] = last_show_args

func on_load(game_version:String) -> void:
	if not register:
		return

	node_link =  Rakugo.get_node_link(node_id)
	visible = node_link.value["visible"]

	if visible:
		_state = node_link.value["state"]
		last_show_args = node_link.value["show_args"]
		_on_show(node_id, _state, last_show_args)

	else:
		_on_hide(node_id)
