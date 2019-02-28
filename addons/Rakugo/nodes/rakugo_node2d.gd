extends Node2D
class_name RakugoNode2D

onready var rnode : = RakugoNodeCore.new()

export var auto_define : = false
export var node_id : = ""
export var camera : = NodePath("")
export(Array, String) var state : Array setget _set_state, _get_state

var _state : Array


func _ready() -> void:
	hide()
	Rakugo.connect("show", self, "_on_show")
	Rakugo.connect("hide", self, "_on_hide")

	if node_id.empty():
		node_id = name

	if auto_define:
		Rakugo.node_link(self, node_id)

func _on_show(node_id : String, state_value : Array, show_args : Dictionary) -> void:
	if self.node_id != node_id:
		return
	
	var cam_pos = Vector2(0, 0)
	
	if !camera.is_empty():
		cam_pos = get_node(camera).positon
		
	position = rnode.show_at(cam_pos, show_args)
	
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
