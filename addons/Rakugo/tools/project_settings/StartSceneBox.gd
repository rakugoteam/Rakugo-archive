tool
extends HBoxContainer

export var root_path : NodePath
onready var root = get_node(root_path)

func _ready() -> void:
	$Button.icon = get_icon("PlayScene", "EditorIcons")
	$Button.connect("pressed", $Button/FileDialog, "popup_centered")
	$Button/FileDialog.connect("confirmed", self, "_on_fd")


func _on_toggled() -> void:
	$Button.disabled = ! $Button.disabled
	$Button.text = ""


func load_setting(use_cfg:bool, cfg:ConfigFile) -> void:
	if use_cfg and cfg:
		$Button.text = cfg.get_value("application", "run/main_scene")
		return
	
	$Button.text = ProjectSettings.get_setting(
		"application/run/main_scene")


func save_setting(use_cfg:bool, cfg:ConfigFile) -> void:
	if use_cfg and cfg:
		cfg.set_value("application", "run/main_scene", $Button.text)
		return
	
	ProjectSettings.set_setting(
		"application/run/main_scene", $Button.text)


func _on_fd():
	$Button.text = $Button/FileDialog.current_path
