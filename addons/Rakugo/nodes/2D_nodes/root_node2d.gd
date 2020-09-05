extends Node2D
class_name RootNode2D, "res://addons/Rakugo/icons/rakugo_root_node2d.svg"

export var root := true

func _ready() -> void:
	if Rakugo.current_root_node != self and root:
		Rakugo.current_root_node = self
