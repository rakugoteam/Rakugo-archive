tool
extends Control
class_name RakugoBaseControl, "res://addons/Rakugo/icons/rakugo_base_control.svg"

export var use_theme_from_setting: bool setget set_use_theme_form_settings, get_use_theme_form_settings

var _use_theme_from_settings := true

func set_use_theme_form_settings(value: bool):
	if value:
		load_theme()

	_use_theme_from_settings = value


func get_use_theme_form_settings() -> bool:
	if _use_theme_from_settings:
		load_theme()

	return _use_theme_from_settings


func load_theme():
	var path = ProjectSettings.get_setting("application/rakugo/theme")
	var cfg_path = ProjectSettings.get_setting("application/config/project_settings_override")
	if cfg_path:
		var cfg := ConfigFile.new()
		cfg.load(cfg_path) 
		path = cfg.get_value("application", "rakugo/theme")

	theme = load(path)
