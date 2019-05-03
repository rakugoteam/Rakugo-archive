extends RakugoBaseButton
class_name RakugoButton 

export var node_path : = NodePath()
export var auto_resize_x : = true
export var auto_resize_y : = true

func _ready() -> void:
	node_to_change = get_node(node_path)

func _on_resized() -> void:
	if auto_resize_x:
		node_to_change.rect_size.x = rect_size.x
	
	if auto_resize_y:
		node_to_change.rect_size.y = rect_size.y

