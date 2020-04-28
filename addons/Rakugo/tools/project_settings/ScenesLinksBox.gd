tool
extends HBoxContainer

var rps : RakugoProjectSettings

func _ready() -> void:
	$ScenesLinksChooser.connect("cancel", self, "_on_reload")


func _on_reload() -> void:
	load_setting()


func load_setting() -> void:
	$ScenesLinksChooser.text = rps.get_setting("rakugo/scenes_links")


func save_setting() -> void:
	$ScenesLinksChooser.text = rps.set_setting(
		"rakugo/scenes_links", $ScenesLinksChooser.text)
	
	$ScenesLinksChooser._on_set_as_def(rps)
