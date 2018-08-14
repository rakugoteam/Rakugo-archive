extends Node2D

onready var rnode = preload("res://addons/Ren/nodes/ren_node_core.gd").new()

export(bool) var auto_define
export(String) var node_id = ""
export(NodePath) var camera = NodePath("")

func _ready():
	hide()
	Ren.connect("show", self, "_on_show")
	Ren.connect("hide", self, "_on_hide")

	if auto_define:
		Ren.node_link(self, node_id)

func _on_show(node_id, state, show_args):
	if self.node_id != node_id:
		return
	
	var cam_pos = Vector2(0, 0)
	
	if !camera.is_empty():
		cam_pos = get_node(camera).positon
		
	position = rnode.show_at(cam_pos, show_args)
	
	if "z" in show_args:
		z_index = show_args.z
	
	on_state(state)

	if not self.visible:
		show()


func on_state(state):
	pass

func _on_hide(_node_id):
	if _node_id != node_id:
		return
		
	hide()

func _exit_tree():
	Ren.variables.erase(node_id)
