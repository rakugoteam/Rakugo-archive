tool
extends WindowDialog

var boxes : Array

func _ready() -> void:
	boxes = $ScrollContainer/VBoxContainer.get_children()
	connect("confirmed", self, "_on_ok")


func load_settings() -> void:
	for box in boxes:
		box.load_setting()


func _on_ok() -> void:
	for box in boxes:
		box.save_setting()



