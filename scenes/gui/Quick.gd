## This is in-game gui example for Ren API ##
## version: 0.5.0 ##
## License MIT ##

extends HBoxContainer


func _ready():
	Ren.connect("enter_statement", self, "_on_statement")
	$Back.connect("pressed", Ren, "rollback")
	$Back.disabled = true
	
	$Auto.connect("pressed", self, "on_auto")
	$AutoTimer.connect("timeout", self, "on_auto_loop")
	
	$Skip.connect("pressed", self, "on_skip")
	$SkipTimer.connect("timeout", self, "on_skip_loop")
	$Skip.disabled = true

	$History.disabled = true
	
	$QSave.connect("pressed", self, "_on_qsave")
	$QLoad.connect("pressed",self, "_on_qload")
	
	$Save.connect("pressed", self, "full_save")
	$Load.connect("pressed", self, "full_load")

func _on_qsave():
	if Ren.savefile():
		$InfoAnim.play("Saved")
	else:
		$InfoAnim/Panel/Label.bbcode_text="[color=red]Error saving Game[/color]"
		$InfoAnim.play("GeneralNotif")

func _on_qload():
	if Ren.loadfile():
		$InfoAnim.play("Loaded")
	else:
		$InfoAnim/Panel/Label.bbcode_text="[color=red]Error loading Game[/color]"
		$InfoAnim.play("GeneralNotif")

func _on_statement(id, type, kwargs):
	$Skip.disabled = !Ren.can_skip()
	$History.disabled = Ren.history.empty()
	
	if Ren.history_id > Ren.history.size():
		$Back.disabled = true
		
	else:
		$Back.disabled = Ren.history.empty()

func on_auto():
	if not $AutoTimer.is_stopped():
		$AutoTimer.stop()
		return
	
	$AutoTimer.start()

func on_auto_loop():
	if Ren.current_statement.type == "say":
		Ren.emit_signal("exit_statement", {})

	else:
		$AutoTimer.stop()


func stop_skip():
	$SkipTimer.stop()
	$InfoAnim.stop()
	$InfoAnim/Panel.hide()

func on_skip():
	if not $SkipTimer.is_stopped():
		stop_skip()
		return
	
	$SkipTimer.start()
	$InfoAnim.play("Skip")

func on_skip_loop():
	if (Ren.current_statement.type == "say"
		and Ren.current_statement in Ren.history):
		Ren.emit_signal("exit_statement", {})
	else:
		stop_skip()

func _input(event):
	if event.is_action("ren_backward"):
		on_rollback()

func full_save():
	var screenshot=get_viewport().get_texture().get_data()
	get_node("../../Screens").save_menu(screenshot)

func full_load():
	get_node("../../Screens").load_menu()
	
