tool
extends HBoxContainer

var rps : RakugoProjectSettings

func _ready() -> void:
	$SceneLinksChooser.connect("cancel", self, "_on_reload")


func _on_reload() -> void:
	load_setting()


func load_setting() -> void:
	$SceneLinksChooser.text = rps.get_setting("rakugo/scene_links")


func save_setting() -> void:
	rps.set_setting("rakugo/scene_links", $SceneLinksChooser.text)
