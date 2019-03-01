extends Timer
class_name SkipTimer

signal stop_loop

func _ready() -> void:
	connect("timeout", self, "on_loop")

func stop_loop() -> void:
	stop()
	emit_signal("stop_loop")
	Rakugo.skip_auto = false

func run() -> bool:
	if not is_stopped():
		stop_loop()
		return false

	Rakugo.skip_auto = true
	start()
	return true

func on_loop() -> void:
	if !Rakugo.can_skip():
		if not Rakugo.get_value("skip_all_text"):
			stop_loop()
			return

	if Rakugo.current_statement.type in Rakugo.skip_types:
		Rakugo.exit_statement()
		return

	stop_loop()
