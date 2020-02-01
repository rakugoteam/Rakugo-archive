tool
extends HBoxContainer

func _ready() -> void:
	$TextureRect.texture = get_icon("Debug", "EditorIcons")


func load_setting(use_cfg:bool, cfg:ConfigFile) -> void:
	if use_cfg:
		$CheckButton.pressed = cfg.get_value("application", "rakugo/debug")
		return

	$CheckButton.pressed = ProjectSettings.get_setting(
		"application/rakugo/debug")


func save_setting(use_cfg:bool, cfg:ConfigFile) -> void:
	if use_cfg:
		cfg.set_value("application", "rakugo/debug", $CheckButton.pressed)
		return

	ProjectSettings.set_setting(
		"application/rakugo/debug", $CheckButton.pressed)
