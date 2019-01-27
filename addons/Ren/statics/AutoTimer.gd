extends RenTimer
class_name AutoTimer

signal stop_loop

func _ready() -> void:
	connect("timeout", self, "on_loop")

func stop_loop() -> void:
	stop()
	emit_signal("stop_loop")
	Ren.skip_auto = false

func run() -> bool:
	if not is_stopped():
		stop_loop()
		return false
	
	Ren.skip_auto = true
	start()
	return true

func on_loop() -> void:
	if Ren.can_auto():
		Ren.exit_statement()
	
	else:
		stop_loop()