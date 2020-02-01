tool
extends HBoxContainer


func _ready() -> void:
	var icon = get_icon("Label", "EditorIcons")
	$TextureRect.texture = icon


func load_setting(use_cfg:bool, cfg:ConfigFile) -> void:
	if use_cfg:
		$LineEdit.text = cfg.get_value("application", "rakugo/version")
		return
		
	$LineEdit.text = ProjectSettings.get_setting(
		"application/rakugo/version")


func save_setting(use_cfg:bool, cfg:ConfigFile) -> void:
	if use_cfg:
		cfg.set_value("application", "rakugo/version", $LineEdit.text)
		return
		
	ProjectSettings.set_setting(
		"application/rakugo/version", $LineEdit.text)
