tool
extends HBoxContainer

export var root_path : NodePath
onready var root = get_node(root_path)

func _ready() -> void:
	$Button.icon = get_icon("ScriptExtend", "EditorIcons")
	$Button.connect("pressed", $FileDialog, "popup_centered")
	$FileDialog.connect("confirmed", self, "_on_fd")
	$Reload.icon = get_icon("Reload", "EditorIcons")
	$Reload.connect("pressed", self, "_on_reload")
	$CheckButton.connect("pressed", self, "_on_toggled")


func _on_toggled() -> void:
	$Button.disabled = ! $Button.disabled
	$Button.text = ""


func _on_reload() -> void:
	load_setting()
	
	for ch in get_parent().get_children():
		if ch != self:
			ch.load_setting(root.use_cfg, root.cfg)


func load_setting(use_cfg:=false, cfg:ConfigFile = null) -> void:

	if $Button.text:
		$CheckButton.pressed = true
		
		if root.cfg == null:
			root.cfg = ConfigFile.new()
			
		root.cfg.load($Button.text)


func save_setting(use_cfg:=false, cfg:ConfigFile = null) -> void:
	
	for ch in get_parent().get_children():
		if ch != self:
			ch.save_setting(root.use_cfg, root.cfg)

	if root.use_cfg and root.cfg:
		root.cfg.save($Button.text)
		root.cfg_path = $Button.text
	
	ProjectSettings.set_setting(
		"application/config/project_settings_override",
		 $Button.text
		)


func _on_fd():
	$Button.text = $FileDialog.current_path
	root.cfg_path = $Button.text
	root.cfg.load($Button.text)
	root.load_settings()
