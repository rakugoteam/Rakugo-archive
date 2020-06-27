tool
extends HBoxContainer

var rps : RakugoProjectSettings

func _ready() -> void:
	$TextureRect.texture = get_icon("Debug", "EditorIcons")


func load_setting() -> void:
	$CheckButton.pressed = rps.get_setting("rakugo/debug")


func save_setting() -> void:
	rps.set_setting("rakugo/debug", $CheckButton.pressed)
