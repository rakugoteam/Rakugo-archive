tool
extends RakugoBaseButton
class_name SaveButton

func _ready() -> void:
	if not use_theme_from_setting:
		return

	var t = theme as RakugoTheme
	add_stylebox_override("disabled", t.save_button_disabled)
	add_stylebox_override("focus", t.save_button_focus)
	add_stylebox_override("hover", t.save_button_hover)
	add_stylebox_override("normal", t.save_button_normal)
	add_stylebox_override("pressed", t.save_button_pressed)

func set_use_theme_form_settings(value:bool):
	.set_use_theme_form_settings(value)
	_ready()
