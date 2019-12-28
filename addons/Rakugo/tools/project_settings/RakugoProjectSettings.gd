tool
extends WindowDialog


func _ready() -> void:
	connect("confirmed", self, "_on_ok")


func load_settings() -> void:
	$ScrollContainer/VBoxContainer/VersionBox.load_setting()
	$ScrollContainer/VBoxContainer/GameCreditsBox.load_setting()
	$ScrollContainer/VBoxContainer/MarkupBox.load_setting()
	$ScrollContainer/VBoxContainer/KindBox.load_setting()
	$ScrollContainer/VBoxContainer/ThemeBox.load_setting()
	$ScrollContainer/VBoxContainer/ScenesLinksBox.load_setting()
	$ScrollContainer/VBoxContainer/DebugBox.load_setting()
	$ScrollContainer/VBoxContainer/SaveBox.load_setting()


func _on_ok() -> void:
	$ScrollContainer/VBoxContainer/VersionBox.save_setting()
	$ScrollContainer/VBoxContainer/GameCreditsBox.save_setting()
	$ScrollContainer/VBoxContainer/MarkupBox.save_setting()
	$ScrollContainer/VBoxContainer/KindBox.save_setting()
	$ScrollContainer/VBoxContainer/ThemeBox.save_setting()
	$ScrollContainer/VBoxContainer/ScenesLinksBox.save_setting()
	$ScrollContainer/VBoxContainer/DebugBox.save_setting()
	$ScrollContainer/VBoxContainer/SaveBox.save_setting()



