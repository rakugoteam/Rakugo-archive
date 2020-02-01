tool
extends HBoxContainer

export var root_path : NodePath
onready var root = get_node(root_path)

func _ready() -> void:
	$Button.icon = get_icon("ScriptExtend", "EditorIcons")
	$Button.connect("pressed", $Button/FileDialog, "popup_centered")
	$Button/FileDialog.connect("confirmed", self, "_on_fd")
	$Reload.icon = get_icon("Reload", "EditorIcons")
	$Reload.connect("pressed", self, "_on_reload")
	$CheckButton.connect("pressed", self, "_on_toggled")


func _on_toggled() -> void:
	$Button.disabled = ! $Button.disabled
	$Button.text = ""


func _on_reload() -> void:
	load_setting()
	root.load_setting()


func load_setting(use_cfg:=false, cfg:ConfigFile = null) -> void:
	$Button.text = ProjectSettings.get_setting(
		"application/config/project_settings_override")

	if $Button.text:
		$CheckButton.pressed = true
		
		if root.cfg == null:
			root.cfg = ConfigFile.new()
			
		root.cfg.load($Button.text)


func save_setting(use_cfg:=false, cfg:ConfigFile = null) -> void:
	root.use_cfg = $CheckButton.pressed
	root.cfg.load($Button.text)
	ProjectSettings.set_setting(
		"application/config/project_settings_override", $Button.text)


func _on_fd():
	$Button.text = $Button/FileDialog.current_path
	root.cfg_path = $Button.text
