tool
extends HBoxContainer

var rps : RakugoProjectSettings

func _ready() -> void:
	$Button.icon = get_icon("Theme", "EditorIcons")
	$Button.connect("pressed", $Button/FileDialog, "popup_centered")
	$Button/FileDialog.connect("confirmed", self, "_on_fd")
	$Reload.icon = get_icon("Reload", "EditorIcons")
	$Reload.connect("pressed", self, "_on_reload")


func _on_reload() -> void:
	$Button.text = rps.get_setting("rakugo/theme")


func load_setting() -> void:
	$Button.text = rps.get_setting("rakugo/theme")


func save_setting() -> void:
	rps.set_setting("rakugo/theme", $Button.text)


func _on_fd():
	$Button.text = $Button/FileDialog.current_path
