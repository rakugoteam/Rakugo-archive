tool
extends HBoxContainer

var rps : RakugoProjectSettings

func _ready() -> void:
	$TextureRect2.texture = get_icon("NodeWarning", "EditorIcons")


func load_setting() -> void:
	$CheckButton.pressed = rps.get_setting("rakugo/test_saves")


func save_setting() -> void:
	rps.set_setting("rakugo/test_saves", $CheckButton.pressed)
