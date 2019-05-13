extends Node2D

var default
var prev

func _ready() -> void:
	default = settings.default_window_size
	prev = default
	scale = OS.window_size / default
	settings.connect("window_size_changed", self, "_on_window_size_changed")

func _on_window_size_changed(prev : Vector2, now : Vector2) -> void:
	scale = now / default
	prev = prev

func _process(delta: float) -> void:
	var now = OS.window_size
	
	if prev != now:
		prev = now
		scale = now / default
		settings.temp_window_size = now
		settings.apply(true)
		