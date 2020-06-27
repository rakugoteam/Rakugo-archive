tool
extends HBoxContainer

var rps : RakugoProjectSettings

var file := File.new()

func _ready() -> void:
	$TextureRect.texture = get_icon("RichTextLabel", "EditorIcons")
	$Button.icon = get_icon("Load", "EditorIcons")
	$Button.connect("pressed", $Button/FileDialog, "popup_centered")
	$Button/FileDialog.connect("confirmed", self, "_on_fd")


func load_setting() -> void:
	$TextEdit.text = rps.get_setting("rakugo/game_credits")


func save_setting() -> void:
	rps.set_setting("rakugo/game_credits", $TextEdit.text)


func _on_fd():
	var current_path = $Button/FileDialog.current_path
	file.open(current_path, file.READ)
	$TextEdit.text = file.get_as_text()
	file.close()
