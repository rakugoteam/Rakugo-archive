tool
extends HBoxContainer
onready var tres_dialog := $Control/FileDialog

signal apply
signal cancel
signal open(file_path)

func _ready() -> void:
	$Choose.connect("pressed", self, "_on_browse_file")
	tres_dialog.connect("confirmed", self, "_on_tres_dialog")
	$Apply.connect("pressed", self, "emit_signal", ["apply"])
	$Cancel.connect("pressed", self, "emit_signal", ["cancel"])


func _on_browse_file() -> void:
	tres_dialog.current_path = $LineEdit.text
	tres_dialog.popup_centered()


func _on_tres_dialog() -> void:
	$LineEdit.text = tres_dialog.current_path
	emit_signal("open", tres_dialog.current_path)


