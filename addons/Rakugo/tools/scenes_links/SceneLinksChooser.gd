tool
extends HBoxContainer

export var only_open := false setget _set_only_open, _get_only_open
onready var tres_dialog := $Control/FileDialog

signal apply
signal cancel
signal set_as_def
signal open(file_path)

func _ready() -> void:
	$Choose.icon = get_icon("Folder", "EditorIcons")
	$Cancel.icon = get_icon("Reload", "EditorIcons")
	$HBoxContainer/Apply.icon = get_icon("Save", "EditorIcons")
	$HBoxContainer/SetAsDef.icon = get_icon("GDScript", "EditorIcons")

	tres_dialog.connect("confirmed", self, "_on_tres_dialog")
	$Choose.connect("pressed", self, "_on_browse_file")
	$Cancel.connect("pressed", self, "emit_signal", ["cancel"])
	$HBoxContainer/Apply.connect("pressed", self, "emit_signal", ["apply"])
	$HBoxContainer/SetAsDef.connect("pressed", self, "_on_set_as_def")


func _on_browse_file() -> void:
	tres_dialog.current_path = $LineEdit.text
	tres_dialog.popup_centered()


func _on_tres_dialog() -> void:
	$LineEdit.text = tres_dialog.current_path
	emit_signal("open", tres_dialog.current_path)


func _on_set_as_def(use_cfg:=false, cfg:ConfigFile=null) -> void:
	ProjectSettings.set_setting(
		"application/rakugo/scenes_links", $LineEdit.text)
	emit_signal("set_as_def")


func _set_only_open(value:bool) -> void:
	$HBoxContainer.visible = !value


func _get_only_open() -> bool:
	return !$HBoxContainer.visible
