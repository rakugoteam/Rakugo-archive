extends Node
class_name RootNode, "res://addons/Rakugo/icons/rakugo_root_node.svg"

export var root := true


func _ready() -> void:
	if Rakugo.current_root_node != self and root:
		Rakugo.current_root_node = self
