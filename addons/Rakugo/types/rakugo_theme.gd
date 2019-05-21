tool
extends Theme
class_name RakugoTheme #, "res://addons/Rakugo/icons/theme.svg"

export var links_color : = Color("#225ebf")
export var idle_node_color : = Color(0.533333, 0.533333, 0.533333, 1)
export var focus_node_color : = Color(0, 0.506836, 0.675781, 1)
export var hover_node_color : = Color(0.877647, 0.882353, 0.887059, 1)
export var pressed_node_color : = Color(0, 0.6, 0.8, 1)
export var disable_node_color : = Color(0.533333, 0.533333, 0.498039, 0.533333)

export var save_button_disabled : StyleBoxFlat setget _set_button_disabled, _get_button_disabled
export var save_button_focus : StyleBoxFlat setget _set_button_focus, _get_button_focus
export var save_button_hover : StyleBoxFlat setget _set_button_hover, _get_button_hover
export var save_button_normal : StyleBoxFlat setget _set_button_normal, _get_button_normal
export var save_button_pressed : StyleBoxFlat setget _set_button_pressed, _get_button_pressed

var _save_button_disabled : StyleBoxFlat
var _save_button_focus : StyleBoxFlat
var _save_button_hover : StyleBoxFlat
var _save_button_normal : StyleBoxFlat
var _save_button_pressed : StyleBoxFlat

func _set_button_disabled(s : StyleBoxFlat):
	_save_button_disabled = s

func _get_button_disabled() -> StyleBoxFlat:
	if(_save_button_disabled == null):
		_save_button_disabled = get_stylebox("disabled", "Button") as StyleBoxFlat

	return _save_button_disabled

func _set_button_focus(s : StyleBoxFlat):
	_save_button_focus = s

func _get_button_focus() -> StyleBoxFlat:
	if(_save_button_focus == null):
		_save_button_focus = get_stylebox("focus", "Button") as StyleBoxFlat

	return _save_button_focus

func _set_button_hover(s : StyleBoxFlat):
	_save_button_hover = s

func _get_button_hover() -> StyleBoxFlat:
	if(_save_button_hover == null):
		_save_button_hover = get_stylebox("hover", "Button") as StyleBoxFlat

	return _save_button_hover

func _set_button_normal(s : StyleBoxFlat):
	_save_button_normal = s

func _get_button_normal() -> StyleBoxFlat:
	if(_save_button_normal == null):
		_save_button_normal = get_stylebox("normal", "Button") as StyleBoxFlat

	return _save_button_normal

func _set_button_pressed(s : StyleBoxFlat):
	_save_button_pressed = s

func _get_button_pressed() -> StyleBoxFlat:
	if(_save_button_pressed == null):
		_save_button_pressed = get_stylebox("pressed", "Button") as StyleBoxFlat

	return _save_button_pressed
