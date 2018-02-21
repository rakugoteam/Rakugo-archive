## This is in-game gui example for Ren API ##
## version: 0.5.0 ##
## License MIT ##

extends HBoxContainer

onready var ren = get_node("/root/Window")

func _ready():
	# $Back.connect("pressed", self, "on_rollback")
	
	$Auto.connect("pressed", self, "on_auto")
	$AutoTimer.connect("timeout", self, "on_auto_loop")
	
	$Skip.connect("pressed", self, "on_skip")
	$SkipTimer.connect("timeout", self, "on_skip_loop")
	

func on_auto():
	if not $AutoTimer.is_stopped():
		$AutoTimer.stop()
		return
	
	$AutoTimer.start()

func on_auto_loop():
	if ren.current_statement.type == "say":
		ren.emit_signal("exit_statement", {})

	else:
		$AutoTimer.stop()

func on_skip():
	if not $SkipTimer.is_stopped():
		$SkipTimer.stop()
		return
	
	$SkipTimer.start()

func on_skip_loop():
	if (ren.current_statement.type == "say"
		and ren.current_statement in ren.history):
		ren.emit_signal("exit_statement", {})
	
	else:
		$SkipTimer.stop()

func on_rollback():
	pass
# 	if back_timer != null:
# 		back_timer.free()
		
# 	back_timer = _new_timer(0.5, true)
# 	back_timer.start()
# 	ren.rollback()
# 	$Back.disconnect("pressed", self, "on_rollback")
# 	yield(back_timer, "timeout")
# 	$Back.connect("pressed", self, "on_rollback")

func _input(event):
	if event.is_action("ren_backward"):
		on_rollback()

