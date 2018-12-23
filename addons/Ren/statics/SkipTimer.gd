extends Timer

signal stop_loop

func _ready():
	connect("timeout", self, "on_loop")

func run():
	if not is_stopped():
		stop()
		Ren.skip_auto = false
		return false

	Ren.skip_auto = true
	start()
	return true

func on_loop():
	if not Ren.current_statement_in_global_history():
		if not Ren.get_value("skip_all_text"):
			stop()
			emit_signal("stop_loop")

	if Ren.current_statement.type in Ren.skip_types:
		Ren.exit_statement()

	else:
		stop()
		emit_signal("stop_loop")
