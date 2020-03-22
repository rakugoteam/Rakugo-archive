tool
extends HBoxContainer

var file := File.new()

func _ready() -> void:
	$TextureRect.texture = get_icon("RichTextLabel", "EditorIcons")
	$Button.icon = get_icon("Load", "EditorIcons")
	$Button.connect("pressed", $Button/FileDialog, "popup_centered")
	$Button/FileDialog.connect("confirmed", self, "_on_fd")


func load_setting(use_cfg:bool, cfg:ConfigFile) -> void:
	if use_cfg and cfg:
		$TextEdit.text = cfg.get_value("application", "rakugo/game_credits")
		return

	$TextEdit.text = ProjectSettings.get_setting(
		"application/rakugo/game_credits")


func save_setting(use_cfg:bool, cfg:ConfigFile) -> void:
	if use_cfg and cfg:
		cfg.set_value("application", "rakugo/game_credits", $TextEdit.text)
		return

	ProjectSettings.set_setting("application/rakugo/game_credits", $TextEdit.text)


func _on_fd():
	var current_path = $Button/FileDialog.current_path
	file.open(current_path, file.READ)
	$TextEdit.text = file.get_as_text()
	file.close()
