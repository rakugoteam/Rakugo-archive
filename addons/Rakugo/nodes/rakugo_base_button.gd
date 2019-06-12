tool
extends Button
class_name RakugoBaseButton

export var use_theme_from_setting : bool setget set_use_theme_form_settings, get_use_theme_form_settings
export var use_form_theme : bool setget set_use_from_theme, get_use_from_theme
export var color_node : = true
export (NodePath) var node_to_change_path

## theme (RakugoTheme), if any, will override this
export var idle_node_color : = Color(0.533333, 0.533333, 0.533333, 1)
export var focus_node_color : = Color(0, 0.506836, 0.675781, 1)
export var hover_node_color : = Color(0.877647, 0.882353, 0.887059, 1)
export var pressed_node_color : = Color(0, 0.6, 0.8, 1)
export var disable_node_color : = Color(0.533333, 0.533333, 0.498039, 0.533333)

onready var node_to_change = get_node(node_to_change_path)

var _use_theme_from_settings := true
var _use_from_theme := true

func _ready() -> void:
	connect("focus_entered", self, "_on_focus")
	connect("focus_exited", self, "_on_idle")
	connect("mouse_entered", self, "_on_hover")
	connect("mouse_exited", self, "_on_idle")
	connect("resized", self, "_on_resized")
	connect("toggled", self, "_on_toggled")
	connect("pressed", self, "_on_pressed")

func set_use_from_theme(value:bool):
	_use_from_theme = value

	if !value:
		return

	upadate_colors()

func upadate_colors():
	var rt := theme as RakugoTheme
	idle_node_color = rt.idle_node_color
	focus_node_color = rt.focus_node_color
	hover_node_color = rt.hover_node_color
	pressed_node_color = rt.pressed_node_color
	disable_node_color = rt.disable_node_color

func get_use_from_theme() -> bool:
	if _use_from_theme:
		upadate_colors()

	return _use_from_theme

func set_use_theme_form_settings(value:bool):
	if value:
		load_theme()

	_use_theme_from_settings = value

func get_use_theme_form_settings() -> bool:
	if _use_theme_from_settings:
		load_theme()

	return _use_theme_from_settings

func load_theme():
	theme = load(
		ProjectSettings.get_setting(
			"application/rakugo/theme"
		)
	)

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
