extends Node2D
class_name RootNode2D

export var root : = false
export var default : = Vector2(1024, 600)
var prev

func _ready() -> void:
	if Rakugo.current_root_node != self and root:
		Rakugo.current_root_node = self

	prev = default
	scale = OS.window_size / default

func _on_window_size_changed(prev : Vector2, now : Vector2) -> void:
	scale = now / default
	prev = prev

func _process(delta: float) -> void:
	var now = OS.window_size

	if prev != now:
		prev = now
		scale = now / default
