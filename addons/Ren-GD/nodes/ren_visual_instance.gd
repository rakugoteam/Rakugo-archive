extends VisualInstance
class_name RenVisualInstance, "res://addons/Ren-GD/icons/ren_spatial.svg"

var rnode : = RenNodeCore.new()

export var auto_define : = false
export var node_id : = ""
export var camera : = NodePath("")
export (Array, String) var state : Array setget _set_state, _get_state

var _state : Array

func _ready() -> void:
	Ren.connect("show", self, "_on_show")
	Ren.connect("hide", self, "_on_hide")
		
	if node_id.empty():
		node_id = name
	
	if auto_define:
		Ren.node_link(self, node_id)
	
func _on_show(node_id : String, state_value : Array, show_args : Dictionary) -> void:
	if self.node_id != node_id:
		return
	
	var cam_pos = Vector2(0, 0)

	if !camera.is_empty():
		if 'x' in show_args:
			cam_pos.x = get_node(camera).project_position(Vector2(show_args.x,0))
		
		if 'y' in show_args:
			cam_pos.y = get_node(camera).project_position(Vector2(show_args.y,0))
		
		var pos = rnode.show_at(cam_pos, show_args)
		
		var z = translation.z
		if z in show_args:
			z = show_args.z
		
		translation = Vector3(pos.x, pos.y, z)
	
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
	Ren.variables.erase(node_id)
