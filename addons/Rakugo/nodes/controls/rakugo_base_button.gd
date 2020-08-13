tool
extends Button
class_name RakugoBaseButton, "res://addons/Rakugo/icons/rakugo_base_button.svg"

export var color_node := true
export var node_to_change_path := NodePath()

# theme (RakugoTheme), if any, will override this
export var use_colors_from_theme := true setget set_colors_from_theme, are_colors_from_theme

export var idle_node_color := Color(0.533333, 0.533333, 0.533333, 1)
export var focus_node_color := Color(0, 0.506836, 0.675781, 1)
export var hover_node_color := Color(0.877647, 0.882353, 0.887059, 1)
export var pressed_node_color := Color(0, 0.6, 0.8, 1)
export var disable_node_color := Color(0.533333, 0.533333, 0.498039, 0.533333)

onready var node_to_change : CanvasItem = get_node(node_to_change_path)
var _use_colors_from_theme := true


func _ready() -> void:
	connect_if_not("focus_entered", self, "_on_focus")
	connect_if_not("focus_exited", self, "_on_idle")
	connect_if_not("mouse_entered", self, "_on_hover")
	connect_if_not("mouse_exited", self, "_on_idle")
	connect_if_not("resized", self, "_on_resized")
	connect_if_not("toggled", self, "_on_toggled")
	connect_if_not("pressed", self, "_on_pressed")


func connect_if_not(sig:String, target:Node, method:String):
	if !is_connected(sig, target, method):
		connect(sig, target, method)


func upadate_colors():
	load_theme()
	if _use_colors_from_theme:
		var rt := theme as RakugoTheme
		if rt:
			idle_node_color = rt.idle_node_color
			focus_node_color = rt.focus_node_color
			hover_node_color = rt.hover_node_color
			pressed_node_color = rt.pressed_node_color
			disable_node_color = rt.disable_node_color


func set_colors_from_theme(value: bool):
	_use_colors_from_theme = value

	if !value:
		return

	upadate_colors()


func are_colors_from_theme() -> bool:
	if _use_colors_from_theme:
		upadate_colors()

	return _use_colors_from_theme


func _on_resized() -> void:
	if node_to_change:
		node_to_change.rect_size = rect_size


func _on_idle() -> void:
	if node_to_change:
		node_to_change.modulate = idle_node_color


func _on_focus() -> void:
	if node_to_change:
		node_to_change.modulate = focus_node_color


func _on_hover() -> void:
	if node_to_change:
		node_to_change.modulate = hover_node_color


func _on_pressed() -> void:
	if toggle_mode:
		return

	if node_to_change:
		node_to_change.modulate = pressed_node_color


func _on_toggled(toggled: bool) -> void:
	if toggled:
		_on_pressed()
		return

	_on_idle()


func set_disabled(value: bool) -> void:
	.set_disabled(value)

	if value:
		if node_to_change:
			node_to_change.modulate = disable_node_color
		return

	_on_idle()


func load_theme():
	var path = ProjectSettings.get_setting("application/rakugo/theme")
	var cfg_path = ProjectSettings.get_setting("application/config/project_settings_override")
	if cfg_path:
		var cfg := ConfigFile.new()
		cfg.load(cfg_path)
		path = cfg.get_value("application", "rakugo/theme")

	theme = load(path)
