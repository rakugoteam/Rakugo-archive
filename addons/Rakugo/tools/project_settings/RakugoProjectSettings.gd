tool
extends Panel

onready var boxes := $VBoxContainer/ScrollContainer/VBoxContainer
var cfg_path := ""
onready var cfg := ConfigFile.new()
var use_cfg : bool

func _ready() -> void:
	$VBoxContainer/SaveButton.icon = get_icon("Save", "EditorIcons")
	cfg_path = ProjectSettings.get_setting("application/config/project_settings_override")
	
	if cfg_path:
		use_cfg = true
		load_settings()

	$VBoxContainer/SaveButton.connect("pressed", self, "_on_ok")
	connect("visibility_changed", self, "_on_visibility_changed")


func _on_visibility_changed():
	if visible:
		load_settings()

func load_settings() -> void:
	boxes.get_node("OverBox").load_setting()


func _on_ok() -> void:
	boxes.get_node("OverBox").save_setting()
