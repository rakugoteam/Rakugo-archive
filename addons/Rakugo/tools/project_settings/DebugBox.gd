tool
extends HBoxContainer

func _ready() -> void:
	$TextureRect.texture = get_icon("Debug", "EditorIcons")


func load_setting() -> void:
	$CheckButton.pressed = ProjectSettings.get_setting(
		"application/rakugo/debug")


func save_setting() -> void:
	 ProjectSettings.set_setting(
		"application/rakugo/debug", $CheckButton.pressed)