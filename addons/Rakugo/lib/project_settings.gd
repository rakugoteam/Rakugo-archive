tool
extends Node
class_name RakugoProjectSettings

var cfg := ConfigFile.new()
var cfg_path := ""
var cfg_loaded := false
var app := "application"
var pso := app + "/config/project_settings_override"

func _ready() -> void:
	load_cfg()


func get_def_cfg_path() -> String:
	if not cfg_path:
		cfg_path = ProjectSettings.get_setting(pso)

	return cfg_path


func load_cfg(path:="") -> void:
	cfg_loaded = false

	if path:
		cfg_path = path

	else:
		get_def_cfg_path()

	if cfg_path:
		cfg.load(cfg_path)
		cfg_loaded = true


func save_cfg(path:="") -> void:
	if path:
		cfg_path = path

	else:
		get_def_cfg_path()

	if cfg_path:
		cfg.save(cfg_path)
		ProjectSettings.set_setting(pso, cfg_path)


func get_setting(path:String) -> String:
	if cfg_loaded:
			return cfg.get_value(app, path)

	return ProjectSettings.get_setting(app + "/" + path)


func set_setting(path:String, value) -> void:
	if cfg_loaded:
		cfg.set_value(app, path, value)

		if not( path in ["config/name", "run/main_scene"]):
			return

	ProjectSettings.set_setting(app + "/" + path, value)
