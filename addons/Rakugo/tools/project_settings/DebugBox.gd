tool
extends HBoxContainer

export var rps_path : NodePath
onready var rps : RakugoProjectSettings = get_node(rps_path)

func _ready() -> void:
	$TextureRect.texture = get_icon("Debug", "EditorIcons")


func load_setting() -> void:
	$CheckButton.pressed = rps.get_setting("rakugo/debug")


func save_setting() -> void:
	rps.set_setting("rakugo/debug", $CheckButton.pressed)
