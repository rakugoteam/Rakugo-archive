extends Button
class_name RakugoBaseButton

export var use_form_theme : = true
## theme (RakugoTheme), if any, will override this
export var idle_node_color : = Color(0.533333, 0.533333, 0.533333, 1)
export var focus_node_color : = Color(0, 0.506836, 0.675781, 1)
export var hover_node_color : = Color(0.877647, 0.882353, 0.887059, 1)
export var pressed_node_color : = Color(0, 0.6, 0.8, 1)
export var disable_node_color : = Color(0.533333, 0.533333, 0.498039, 0.533333)

var node_to_change : Node

func _ready() -> void:
	if theme != null and use_form_theme:
		var rt := theme as RakugoTheme
		idle_node_color = rt.idle_node_color
		focus_node_color = rt.focus_node_color
		hover_node_color = rt.hover_node_color
		pressed_node_color = rt.pressed_node_color
		disable_node_color = rt.disable_node_color

	connect("focus_entered", self, "_on_focus")
	connect("focus_exited", self, "_on_idle")
	connect("mouse_entered", self, "_on_hover")
	connect("mouse_exited", self, "_on_idle")
	connect("resized", self, "_on_resized")
	connect("toggled", self, "_on_toggled")
	connect("pressed", self, "_on_pressed")

func _on_resized() -> void:
	node_to_change.rect_size = rect_size

func _on_idle() -> void:
	node_to_change.add_color_override(
		"default_color", idle_node_color
	)

func _on_focus() -> void:
	node_to_change.add_color_override(
		"default_color", focus_node_color
	)

func _on_hover() -> void:
	node_to_change.add_color_override(
		"default_color", hover_node_color
	)

func _on_pressed() -> void:
	if toggle_mode:
		return

	node_to_change.add_color_override(
		"default_color", pressed_node_color
	)

func _on_toggled(toggled:bool) -> void:
	if toggled:
		_on_pressed()
		return

	_on_idle()

func set_disabled(value:bool) -> void:
	.set_disabled(value)

	if value:
		node_to_change.add_color_override(
			"default_color", disable_node_color
		)
		return

	_on_idle()
