tool
extends HBoxContainer


func _ready() -> void:
	var icon = get_icon("Label", "EditorIcons")
	$TextureRect.texture = icon


func load_setting() -> void:
	$LineEdit.text = ProjectSettings.get_setting(
		"application/rakugo/version")


func save_setting() -> void:
	 ProjectSettings.set_setting(
		"application/rakugo/version", $LineEdit.text)
