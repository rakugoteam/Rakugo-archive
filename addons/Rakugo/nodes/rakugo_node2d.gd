extends Node2D
class_name RakugoNode2D

onready var rnode : = RakugoNodeCore.new()

export var node_id : = ""
export var camera : = NodePath("")
export(Array, String) var state : Array setget _set_state, _get_state

var _state : Array
var node_link:NodeLink
var last_show_args:Dictionary

func _ready() -> void:
	hide()
	Rakugo.connect("show", self, "_on_show")
	Rakugo.connect("hide", self, "_on_hide")

	if node_id.empty():
		node_id = name
	
	node_link = Rakugo.get_node_link(node_id)
	
	if not node_link:
		node_link = Rakugo.node_link(node_id, get_path())
		
	else:
		node_link.value["node_path"] = get_path()
		
	add_to_group("save", true)

func _on_show(node_id : String, state_value : Array, show_args : Dictionary) -> void:
	if self.node_id != node_id:
		return
	
	var cam_pos = Vector2(0, 0)
	
	if !camera.is_empty():
		cam_pos = get_node(camera).positon
	
	last_show_args = show_args
	position = rnode.show_at(cam_pos, show_args, position)
	
	if "z" in show_args:
		z_index = show_args.z
	
	_set_state(state_value)

	if not self.visible:
		show()

func _set_state(value : Array) -> void:
	_state = state
	
func _get_state() -> Array:
	return _state

func _on_hide(_node_id) -> void:
	if _node_id != node_id:
		return
		
	hide()

func _exit_tree() -> void:
	Rakugo.variables.erase(node_id)

func  on_save() -> void:
	node_link.value["visible"] = visible
	node_link.value["state"] = _state
	node_link.value["show_args"] = last_show_args

func on_load(game_version:String) -> void:
	node_link =  Rakugo.get_node_link(node_id)
	visible = node_link.value["visible"]
	
	if visible:
		_state = node_link.value["state"]
		last_show_args = node_link.value["show_args"] 
		_on_show(node_id, _state , last_show_args )
		
	else:
		_on_hide(node_id)
	
