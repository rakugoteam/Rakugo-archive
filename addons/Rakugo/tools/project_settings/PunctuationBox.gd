tool
extends HBoxContainer


func _ready() -> void:
	$TextureRect.texture = get_icon("RichTextLabel", "EditorIcons")
	$Reload.icon = get_icon("Reload", "EditorIcons")


func load_setting(use_cfg:bool, cfg:ConfigFile) -> void:
	if use_cfg and cfg:
		$SpinBox.value = cfg.get_value("application", "rakugo/punctuation_pause")
		return
		
	$LineEdit.text = ProjectSettings.get_setting(
		"application/rakugo/punctuation_pause")


func save_setting(use_cfg:bool, cfg:ConfigFile) -> void:
	if use_cfg and cfg:
		cfg.set_value("application", "rakugo/punctuation_pause", $SpinBox.value)
		return
		
	ProjectSettings.set_setting(
		"application/rakugo/punctuation_pause", $SpinBox.value)
