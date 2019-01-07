extends "res://addons/Ren/nodes/ren_timer.gd"

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
	if Ren.can_auto():
		Ren.exit_statement()
	
	else:
		stop_loop()