extends Button

export(Color) var idle_node_color = Color(0.533333, 0.533333, 0.533333, 1)
export(Color) var focus_node_color = Color(0, 0.506836, 0.675781, 1)
export(Color) var hover_node_color = Color(0.877647, 0.882353, 0.887059, 1)
export(Color) var pressed_node_color = Color(0, 0.6, 0.8, 1)
export(Color) var disable_node_color = Color(0.533333, 0.533333, 0.498039, 0.533333)
var node_to_change


func _ready():
	connect("focus_entered", self, "_on_focus")
	connect("focus_exited", self, "_on_idle")
	connect("mouse_entered", self, "_on_hover")
	connect("mouse_exited", self, "_on_idle")
	connect("resized", self, "_on_resized")
	connect("toggled", self, "_on_toggled")
	connect("pressed", self, "_on_pressed")

func _on_resized():
	node_to_change.rect_size = rect_size

func _on_idle():
	node_to_change.add_color_override("default_color", idle_node_color)

func _on_focus():
	node_to_change.add_color_override("default_color", focus_node_color)

func _on_hover():
	node_to_change.add_color_override("default_color", hover_node_color)

func _on_pressed():
	if toggle_mode:
		return
	node_to_change.add_color_override("default_color", pressed_node_color)

func _on_toggled(toggled):
	if toggled:
		_on_pressed()
	else:
		_on_idle()

func set_disabled(value):
	.set_disabled(value)
	if value:
		node_to_change.add_color_override("default_color", disable_node_color)
	else:
		_on_idle()
