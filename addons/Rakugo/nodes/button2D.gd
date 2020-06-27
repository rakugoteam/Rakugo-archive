extends Area2D
class_name Button2D, "res://addons/Rakugo/icons/button_2d.svg"

export(int, "LEFT", "RIGHT", "MIDDLE") var mouse_button := 0
export var toggle_mode := false
export var disabled := false setget set_disabled, get_disabled

# theme (RakugoTheme), if any, will override this
export var use_colors_from_theme := true setget set_colors_from_theme, are_colors_from_theme

export var idle_color : Color setget set_idle_color, get_idle_color
export var hover_color := Color(0.877647, 0.882353, 0.887059, 1)
export var pressed_color := Color(0, 0.6, 0.8, 1)
export var disable_color : Color setget set_disabled_color, get_disabled_color

var _use_colors_from_theme := true
var _mouse_in := false
var _disabled := false
var _toggled := false
var _idle_color := Color(0.533333, 0.533333, 0.533333, 1)
var _disable_color := Color(0.533333, 0.533333, 0.498039, 0.533333)

signal toggled(value)
signal pressed

func _ready() -> void:
	upadate_colors()
	modulate = _idle_color
	set_process_input(true)

	connect_if_not("mouse_entered", self, "_on_hover")
	connect_if_not("mouse_exited", self, "_on_idle")
	connect_if_not("toggled", self, "_on_toggled")
	connect_if_not("pressed", self, "_on_pressed")
	

func connect_if_not(sig:String, target:Node, method:String) -> void:
	if !is_connected(sig, target, method):
		connect(sig, target, method)


func upadate_colors() -> void:
	if !_use_colors_from_theme:
		return

	var t = load(
		ProjectSettings.get_setting(
			"application/rakugo/theme"
	))

	var rt := t as RakugoTheme
	_idle_color = rt.idle_node_color
	hover_color = rt.hover_node_color
	pressed_color = rt.pressed_node_color
	_disable_color = rt.disable_node_color


func set_colors_from_theme(value: bool) -> void:
	_use_colors_from_theme = value

	if !value:
		return

	upadate_colors()
	modulate = idle_color


func are_colors_from_theme() -> bool:
	return _use_colors_from_theme


func _on_idle() -> void:
	_mouse_in = false
	modulate = _idle_color
#	print("idle")


func _on_hover() -> void:
	_mouse_in = true
	modulate = hover_color
#	print("hover")


func _on_pressed() -> void:
	if toggle_mode:
		return

	modulate = pressed_color
#	print("pressed")

	_on_hover()


func _on_toggled(toggled: bool) -> void:
	_toggled = toggled

	if toggled:
		modulate = pressed_color

	_on_hover()


func set_disabled(value: bool) -> void:
	_disabled = value

	if _disabled:
		modulate = _disable_color
	else:
		modulate = _idle_color


func get_disabled() -> bool:
	return _disabled


func set_disabled_color(value:Color) -> void:
	_disable_color = value

	if _disabled:
		modulate = value


func get_disabled_color() -> Color:
	return _disable_color


func set_idle_color(value:Color) -> void:
	_idle_color = value

	if !_disabled:
		modulate = value


func get_idle_color() -> Color:
	return _idle_color


func _input(event:InputEvent) -> void:
	if !_mouse_in || _disabled:
		return

	if event is InputEventMouseButton:
		var e = event as InputEventMouseButton

		if e.pressed:
			if e.button_index == mouse_button + 1:

				if toggle_mode:
					emit_signal("toggled", !_toggled)
					return

				emit_signal("pressed")
