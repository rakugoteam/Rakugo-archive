tool
extends HBoxContainer

export var rps_path : NodePath
onready var rps : RakugoProjectSettings = get_node(rps_path)

func _ready() -> void:
	$ScenesLinksChooser.connect("cancel", self, "_on_reload")


func _on_reload() -> void:
	$ScenesLinksChooser/LineEdit.text = "res://game/scenes_links.tres"


func load_setting() -> void:
	$ScenesLinksChooser/LineEdit.text = rps.get_setting("rakugo/scenes_links")


func save_setting() -> void:
	$ScenesLinksChooser/LineEdit.text = rps.set_setting(
	"rakugo/scenes_links", $ScenesLinksChooser/LineEdit.text)

	$ScenesLinksChooser._on_set_as_def(rps.cfg_loaded, rps.cfg)
