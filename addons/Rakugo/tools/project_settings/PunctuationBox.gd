tool
extends HBoxContainer

var rps : RakugoProjectSettings

func _ready() -> void:
	$TextureRect.texture = get_icon("RichTextLabel", "EditorIcons")
	$Reload.icon = get_icon("Reload", "EditorIcons")


func load_setting() -> void:
	$SpinBox.value = int(
		rps.get_setting("rakugo/punctuation_pause"))


func save_setting() -> void:
	rps.set_setting(
		"rakugo/punctuation_pause",
		 str($SpinBox.value))
