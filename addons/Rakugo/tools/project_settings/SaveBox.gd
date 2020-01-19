tool
extends HBoxContainer

func _ready() -> void:
	$TextureRect2.texture = get_icon("NodeWarning", "EditorIcons")

func load_setting() -> void:
	$CheckButton.pressed = ProjectSettings.get_setting(
		"application/rakugo/test_saves")


func save_setting() -> void:
	ProjectSettings.set_setting(
		"application/rakugo/test_saves", $CheckButton.pressed)
