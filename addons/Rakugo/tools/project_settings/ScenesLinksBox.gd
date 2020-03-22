tool
extends HBoxContainer


func _ready() -> void:
	# load_setting()
	$ScenesLinksChooser.connect("cancel", self, "_on_reload")


func _on_reload() -> void:
	$ScenesLinksChooser/LineEdit.text = "res://game/scenes_links.tres"


func load_setting(use_cfg:bool, cfg:ConfigFile) -> void:
	if use_cfg and cfg:
		$ScenesLinksChooser/LineEdit.text  = cfg.get_value("application", "rakugo/scenes_links")
		return

	$ScenesLinksChooser/LineEdit.text = ProjectSettings.get_setting(
		"application/rakugo/scenes_links")


func save_setting(use_cfg:bool, cfg:ConfigFile) -> void:
	if use_cfg and cfg:
		cfg.set_value(
			"application", "rakugo/scenes_links",
			$ScenesLinksChooser/LineEdit.text)

	else:
		$ScenesLinksChooser/LineEdit.text = ProjectSettings.set_setting(
		"application/rakugo/scenes_links", $ScenesLinksChooser/LineEdit.text)
		
	$ScenesLinksChooser._on_set_as_def(use_cfg, cfg)
