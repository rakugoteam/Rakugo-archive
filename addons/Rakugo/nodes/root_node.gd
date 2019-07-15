extends Node
class_name RootNode

export var root := true


func _ready() -> void:
	if Rakugo.current_root_node != self and root:
		Rakugo.current_root_node = self
