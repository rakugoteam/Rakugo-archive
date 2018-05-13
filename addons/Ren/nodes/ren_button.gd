extends Button

export(NodePath) var node_path = NodePath()
export(bool) var auto_resize_x = true
export(bool) var auto_resize_y = true
export(Color) var idle_node_color = Color(0.533333, 0.533333, 0.533333, 1)
export(Color) var focus_node_color = Color(0, 0.506836, 0.675781, 1)
export(Color) var hover_node_color = Color(0.877647, 0.882353, 0.887059, 1)
export(Color) var pressed_node_color = Color(0, 0.6, 0.8, 1)
export(Color) var disable_node_color = Color(0.533333, 0.533333, 0.498039, 0.533333)

onready var node = get_node(node_path)


func _ready():
	connect("focus_entered", self, "_on_focus")
	connect("focus_exited", self, "_on_idle")
	connect("mouse_entered", self, "_on_hover")
	connect("mouse_exited", self, "_on_idle")
	connect("pressed", self, "_on_pressed")
	connect("resized", self, "_on_resized")

func _on_resized():
	if auto_resize_x:
		node.rect_size.x = rect_size.x
	
	if auto_resize_y:
		node.rect_size.y = rect_size.y

func _on_idle():
	node.add_color_override("default_color", idle_node_color)

func _on_focus():
	node.add_color_override("default_color", focus_node_color)

func _on_hover():
	node.add_color_override("default_color", hover_node_color)

func _on_pressed():
	node.add_color_override("default_color", pressed_node_color)

func set_disabled(value):
	.set_disabled(value)
	if value:
		node.add_color_override("default_color", disable_node_color)
	else:
		_on_idle()
