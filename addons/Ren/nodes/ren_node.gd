extends Node

export(String) var node_id = ""
export(NodePath) var camera = NodePath("")

func _ready():
	if is_visual_node():
		Ren.connect("show", self, "_on_show", [], CONNECT_PERSIST)
		Ren.connect("hide", self, "_on_hide", [], CONNECT_PERSIST)
		
	if node_id.empty():
		node_id = name

	Ren.node_link(self, node_id)
	print("Add RenNode ", node_id)

func is_visual_node():
	if self is Control:
		return true
		
	elif self is Node2D:
		return true
		
	elif self is VisualInstance:
		return true
	
	return false

func is_procent(x):
	return (typeof(x) == TYPE_REAL
			and x >= 0.0
			and x <= 1.0)

func show_at(camera_postion, position, size, show_args):
	var x = position.x
	if "x" in show_args:
		x = show_args.x
	
		if is_procent(x) and x != 0:
			x = camera_postion.x + OS.window_size.x * x
			x -= size.x/2
	
	var y = position.y
	if "y" in show_args:
		y = show_args.y
		
		if is_procent(y) and y != 0:
			y = camera_postion.y + OS.window_size.y * y
			y -= size.y/2
	
	var pos = Vector2(x, y)
	if "pos" in show_args:
		pos = show_args.pos
	
	return pos

func _on_show(node_id, state, show_args):
	if node_id != node_id:
		return
	
	var cam_pos = Vector2(0, 0)
	
	if self is Control:
		self.rect_position = show_at(
		Vector2(0, 0), self.rect_position,
		self.rect_size, show_args
		)
	
	elif self is Node2D:
#		if camera.is_empty():
#			cam_pos = get_node(camera).positon
			
		self.position = show_at(
			cam_pos, self.position,
			self.get_viewport_rect().size, show_args
		)
		
		if "z" in show_args:
			self.z_index = show_args.z
	
	elif self is VisualInstance:
		if camera.is_empty():
			if 'x' in show_args:
				cam_pos.x = get_node(camera).project_position(Vector2(show_args.x,0))
			
			if 'y' in show_args:
				cam_pos.y = get_node(camera).project_position(Vector2(show_args.y,0))
		
		var pos = show_at(
			cam_pos, self.translation,
			self.get_aabb().size, show_args
		)
		
		var z = self.translation.z
		if z in show_args:
			z = show_args.z
		
		self.translation = Vector3(pos.x, pos.y, z)
	
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
	Ren.values.erase(node_id)
