extends Timer

signal stop_loop

func _ready():
	connect("timeout", self, "on_loop")

func stop_loop():
	stop()
	emit_signal("stop_loop")
	Ren.skip_auto = false

func run():
	if not is_stopped():
		stop_loop()
		return false

	Ren.skip_auto = true
	start()
	return true

func on_loop():
	if !Ren.can_skip\():
		if not Ren.get_value("skip_all_text"):
			stop_loop()
			return

	if Ren.current_statement.type in Ren.skip_types:
		Ren.exit_statement()
		return

	stop_loop()
