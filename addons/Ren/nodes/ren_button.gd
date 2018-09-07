extends "ren_base_button.gd"

export(NodePath) var node_path = NodePath()
export(bool) var auto_resize_x = true
export(bool) var auto_resize_y = true


func _ready():
	node_to_change = get_node(node_path)

func _on_resized():
	if auto_resize_x:
		node_to_change.rect_size.x = rect_size.x
	
	if auto_resize_y:
		node_to_change.rect_size.y = rect_size.y

