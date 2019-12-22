tool
extends HBoxContainer
onready var tres_dialog := $FreePos/TresDialog

func _ready() -> void:
	$LineEdit.text = Rakugo.scenes_links
	$BrowseFile.connect("pressed", self, "_on_browse_file")
	tres_dialog.connect("confirmed", self, "_on_tres_dialog")


func _on_browse_file() -> void:
	tres_dialog.current_path = $LineEdit.text
	tres_dialog.popup()


func _on_tres_dialog() -> void:
	$LineEdit.text = tres_dialog.current_path


