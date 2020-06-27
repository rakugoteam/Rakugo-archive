tool
extends HBoxContainer

var rps : RakugoProjectSettings

func _ready() -> void:
	$TextureRect.texture = get_icon("Label", "EditorIcons")


func load_setting() -> void:
	$LineEdit.text = rps.get_setting("config/name")


func save_setting() -> void:
	rps.set_setting("config/name", $LineEdit.text)
