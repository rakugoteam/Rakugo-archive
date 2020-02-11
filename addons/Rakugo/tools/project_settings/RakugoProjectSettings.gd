tool
extends WindowDialog

var boxes : Array
var cfg_path := ""
onready var cfg := ConfigFile.new()
var use_cfg : bool

func _ready() -> void:
	cfg_path = ProjectSettings.get_setting(
	 "application/config/project_settings_override")

	if cfg_path:
		use_cfg = true
		cfg.load(cfg_path)

	boxes = $ScrollContainer/VBoxContainer.get_children()
	connect("confirmed", self, "_on_ok")


func load_settings() -> void:
	for box in boxes:
		box.load_setting(use_cfg, cfg)


func _on_ok() -> void:
	for box in boxes:
		box.save_setting(use_cfg, cfg)
	
	if use_cfg and cfg:
		cfg.save(cfg_path)
