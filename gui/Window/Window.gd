extends RootNode2D

func _ready() -> void:
	settings.connect("window_size_changed", self, "_on_window_size_changed")

func _process(delta: float) -> void:
	var now = OS.window_size

	if prev != now:
		settings.temp_window_size = now
		settings.apply(true)
