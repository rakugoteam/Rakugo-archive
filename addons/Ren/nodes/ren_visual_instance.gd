extends VisualInstance

var rnode = load("ren_node_core.gd").new()

export(bool) var auto_define
export(String) var node_id = ""
export(NodePath) var camera = NodePath("")

func _ready():
	Ren.connect("show", self, "_on_show")
	Ren.connect("hide", self, "_on_hide")
		
	if node_id.empty():
		node_id = name
	
	if auto_define:
		Ren.node_link(self, node_id)
	
func _on_show(node_id, state, show_args):
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
