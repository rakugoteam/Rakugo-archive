tool
extends HBoxContainer

func _ready() -> void:
	$Reload.icon = get_icon("Reload", "EditorIcons")
	$Reload.connect("pressed", self, "_on_reload")


func _on_reload() -> void:
	$LineEdit.text = "saves"
	$CheckButton.pressed = false


func load_setting() -> void:
	$LineEdit.text = ProjectSettings.get_setting(
		"application/rakugo/save_folder")
	$CheckButton.pressed = ProjectSettings.get_setting(
		"application/rakugo/test_saves")


func save_setting() -> void:
	ProjectSettings.set_setting(
		"application/rakugo/save_folder", $LineEdit.text)
	ProjectSettings.set_setting(
		"application/rakugo/test_saves", $CheckButton.pressed)
