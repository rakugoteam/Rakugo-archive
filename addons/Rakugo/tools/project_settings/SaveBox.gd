tool
extends HBoxContainer

func _ready() -> void:
	$TextureRect2.texture = get_icon("NodeWarning", "EditorIcons")

func load_setting(use_cfg:bool, cfg:ConfigFile) -> void:
	if use_cfg:
		$CheckButton.pressed = cfg.get_value("application", "rakugo/test_saves")
		return

	$CheckButton.pressed = ProjectSettings.get_setting(
		"application/rakugo/test_saves")


func save_setting(use_cfg:bool, cfg:ConfigFile) -> void:
	if use_cfg:
		cfg.set_value("application", "rakugo/test_saves", $CheckButton.pressed)
		return

	ProjectSettings.set_setting(
		"application/rakugo/test_saves", $CheckButton.pressed)
