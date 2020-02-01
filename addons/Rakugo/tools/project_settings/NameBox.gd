tool
extends HBoxContainer


func _ready() -> void:
	var icon = get_icon("Label", "EditorIcons")
	$TextureRect.texture = icon


func load_setting(use_cfg:bool, cfg:ConfigFile) -> void:
	if use_cfg and cfg:
		$LineEdit.text = cfg.get_value("application", "config/name")
		return
		
	$LineEdit.text = ProjectSettings.get_setting(
		"application/config/name")


func save_setting(use_cfg:bool, cfg:ConfigFile) -> void:
	if use_cfg and cfg:
		cfg.set_value("application", "config/name", $LineEdit.text)
		return
		
	ProjectSettings.set_setting(
		"application/config/name", $LineEdit.text)
