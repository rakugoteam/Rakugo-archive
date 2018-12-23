extends "res://addons/Ren/nodes/ren_timer.gd"


func _ready():
	connect("timeout", self, "on_auto_loop")

func on_auto():
	if not is_stopped():
		stop()
		Ren.skip_auto = false
		return
	
	Ren.skip_auto = true
	start()

func on_auto_loop():
	if Ren.current_statement.type in Ren.skip_types:
		Ren.exit_statement()

	else:
		stop()