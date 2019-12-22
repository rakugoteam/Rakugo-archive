extends RakugoBaseButton

#func _ready() -> void:
#	connect("pressed", self, "_on_pressed")

func _process(delta: float) -> void:
	var d = Rakugo.dialog_timer.time_left == 0
	set_disabled(d)

func on_press() -> void:
		Input.action_press("ui_accept")
		Input.action_release("ui_accept")