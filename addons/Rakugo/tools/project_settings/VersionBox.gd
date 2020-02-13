tool
extends HBoxContainer


func _ready() -> void:
	$TextureRect.texture = get_icon("Label", "EditorIcons")


func load_setting(use_cfg:bool, cfg:ConfigFile) -> void:
	if use_cfg and cfg:
		$LineEdit.text = cfg.get_value("application", "rakugo/version")
		return
		
	$LineEdit.text = ProjectSettings.get_setting(
		"application/rakugo/version")


func save_setting(use_cfg:bool, cfg:ConfigFile) -> void:
	if use_cfg and cfg:
		cfg.set_value("application", "rakugo/version", $LineEdit.text)
		return
		
	ProjectSettings.set_setting(
		"application/rakugo/version", $LineEdit.text)
