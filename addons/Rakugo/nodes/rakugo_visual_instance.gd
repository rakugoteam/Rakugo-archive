tool
extends VisualInstance
class_name RakugoVisualInstance, "res://addons/Rakugo/icons/rakugo_spatial.svg"

var rnode : = RakugoNodeCore.new()

export var node_id : = ""
export var camera : = NodePath("")
export (Array, String) var state : Array setget _set_state, _get_state

var _state : Array
var node_link:NodeLink
var last_show_args:Dictionary

func _ready() -> void:
	if(Engine.editor_hint):
		if node_id.empty():
			node_id = name

		add_to_group("save", true)
		return

	Rakugo.connect("show", self, "_on_show")
	Rakugo.connect("hide", self, "_on_hide")
	rnode.connect("on_substate", self, "_on_rnode_substate")

	if node_id.empty():
		node_id = name

	node_link = Rakugo.get_node_link(node_id)

	if not node_link:
		node_link = Rakugo.node_link(node_id, get_path())

	else:
		node_link.value["node_path"] = get_path()

	add_to_group("save", true)

func _on_rnode_substate(substate):
	emit_signal("on_substate", substate)

func _on_show(node_id : String, state_value : Array, show_args : Dictionary) -> void:
	if self.node_id != node_id:
		return

	var cam_pos = Vector2(0, 0)

	if !camera.is_empty():
		if 'x' in show_args:
			cam_pos.x = get_node(camera).project_position(Vector2(show_args.x,0))

		if 'y' in show_args:
			cam_pos.y = get_node(camera).project_position(Vector2(show_args.y,0))

		var def_pos = Vector2(translation.x , translation.y)
		var pos = rnode.show_at(cam_pos, show_args, def_pos)

		var z = translation.z

		if z in show_args:
			z = show_args.z

		translation = Vector3(pos.x, pos.y, z)

	_set_state(state_value)

	if not self.visible:
		show()

func _set_state(value : Array) -> void:
	_state = value

	if not Engine.editor_hint:
		_state = rnode.setup_state(value)

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

	Rakugo.variables.erase(node_id)

func on_save() -> void:
	node_link.value["visible"] = visible
	node_link.value["state"] = _state
	node_link.value["show_args"] = last_show_args

func on_load(game_version:String) -> void:
	node_link =  Rakugo.get_node_link(node_id)
	visible = node_link.value["visible"]

	if visible:
		_state = node_link.value["state"]
		last_show_args = node_link.value["show_args"]
		_on_show(node_id, _state, last_show_args)

	else:
		_on_hide(node_id)

func _on_substate(substate):
	pass
