tool
extends HBoxContainer

var rps : RakugoProjectSettings

func _ready() -> void:
	$TextureRect.texture = get_icon("PlayScene", "EditorIcons")
	$Button.icon = get_icon("PlayScene", "EditorIcons")
	$Button.connect("pressed", $Button/FileDialog, "popup_centered")
	$Button/FileDialog.connect("confirmed", self, "_on_fd")


func _on_toggled() -> void:
	$Button.disabled = ! $Button.disabled
	$Button.text = ""


func load_setting() -> void:
	$Button.text = rps.get_setting("run/main_scene")


func save_setting() -> void:
	rps.set_setting("run/main_scene", $Button.text)


func _on_fd():
	$Button.text = $Button/FileDialog.current_path
