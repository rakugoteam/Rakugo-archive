tool
extends HBoxContainer

onready var rps : RakugoProjectSettings = $RakugoProjectSettings
export var only_open := false setget _set_only_open, _get_only_open
onready var tres_dialog := $Control/FileDialog

var text setget _set_text, _get_text

signal apply
signal cancel
signal set_as_def
signal open(file_path)
signal new_file(file_path)

func _ready() -> void:
	$Choose.icon = get_icon("Folder", "EditorIcons")
	$Cancel.icon = get_icon("Reload", "EditorIcons")
	$HBoxContainer/New.icon = get_icon("New", "EditorIcons")
	$HBoxContainer/Apply.icon = get_icon("Save", "EditorIcons")
	$HBoxContainer/SetAsDef.icon = get_icon("GDScript", "EditorIcons")

	tres_dialog.connect("confirmed", self, "_on_tres_dialog")
	$Choose.connect("pressed", self, "_on_load_file")
	$HBoxContainer/New.connect("pressed", self, "_on_new_file")
	$Cancel.connect("pressed", self, "emit_signal", ["cancel"])
	$HBoxContainer/Apply.connect("pressed", self, "emit_signal", ["apply"])
	$HBoxContainer/SetAsDef.connect("pressed", self, "_on_set_as_def")


func _set_text(value:String) -> void:
	$LineEdit.text = value


func _get_text() -> String:
	return $LineEdit.text


func load_cfg() -> void:
	rps.load_cfg()
	var path = rps.get_setting("rakugo/scenes_links")
	$LineEdit.text = path
	emit_signal("open", path)


func _on_load_file() -> void:
	tres_dialog.mode = FileDialog.MODE_OPEN_FILE
	tres_dialog.window_title = "Open a ScenesLinks File"

	tres_dialog.current_path = $LineEdit.text
	tres_dialog.popup_centered()


func _on_new_file() -> void:
	tres_dialog.mode = FileDialog.MODE_SAVE_FILE
	tres_dialog.window_title = "Where to Save new ScenesLinks File"

	tres_dialog.current_path = $LineEdit.text
	tres_dialog.popup_centered()


func _on_tres_dialog() -> void:
	$LineEdit.text = tres_dialog.current_path

	if tres_dialog.mode == FileDialog.MODE_OPEN_FILE:
		emit_signal("open", tres_dialog.current_path)

	if tres_dialog.mode == FileDialog.MODE_SAVE_FILE:
		emit_signal("new_file", tres_dialog.current_path)


func _on_set_as_def(_rps := rps) -> void:
	if _rps != rps:
		rps = _rps

	rps.set_setting("rakugo/scenes_links", $LineEdit.text)
	rps.save_cfg()
	emit_signal("set_as_def")


func _set_only_open(value:bool) -> void:
	if value:
		$Label.size_flags_horizontal = SIZE_EXPAND_FILL

	else:
		$Label.size_flags_horizontal = SIZE_FILL

	$HBoxContainer.visible = !value


func _get_only_open() -> bool:
	return !$HBoxContainer.visible
