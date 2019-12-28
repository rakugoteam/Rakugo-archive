tool
extends HBoxContainer


func _ready() -> void:
	var icon = get_icon("RichTextLabel", "EditorIcons")
	$TextureRect.texture = icon


func load_setting() -> void:
	$TextEdit.text = ProjectSettings.get_setting(
		"application/rakugo/game_credits")


func save_setting() -> void:
	 ProjectSettings.set_setting(
		"application/rakugo/game_credits", $TextEdit.text)