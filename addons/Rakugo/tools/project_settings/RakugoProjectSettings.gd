tool
extends Panel

var cfg_path := ""
onready var cfg := ConfigFile.new()
var use_cfg : bool

func get_boxes() -> Node:
	return $VBoxContainer/ScrollContainer/VBoxContainer

func _ready() -> void:
	$VBoxContainer/SaveButton.icon = get_icon("Save", "EditorIcons")
	cfg_path = ProjectSettings.get_setting("application/config/project_settings_override")
	$Label.hide()
	
	if cfg_path:
		use_cfg = true
		load_settings()

	$VBoxContainer/SaveButton.connect("pressed", self, "_on_ok")
	connect("visibility_changed", self, "_on_visibility_changed")


func _on_visibility_changed():
	if visible:
		_ready()


func load_settings() -> void:
	get_boxes().get_node("OverBox").load_setting()
	notify("Loaded");


func _on_ok() -> void:
	get_boxes().get_node("OverBox").save_setting()
	notify("Saved")


func notify(text:String) -> void:
	$Label.text = text
	var scolor = Color(0, 0, 0, 0)
	$Tween.interpolate_property(
		$Label, "modulate", scolor, Color.green,
		1, Tween.TRANS_LINEAR,Tween.EASE_IN)
		
	$Tween.interpolate_property(
		$Label, "modulate", Color.green, scolor,
		1, Tween.TRANS_LINEAR,Tween.EASE_IN, 0.7)
		
	$Label.show()
	$Tween.start()
