extends HBoxContainer

var skip_types = ["say", "show", "hide"]
onready var Screens = get_node("../../Screens")

func _ready():
	Ren.connect("exec_statement", self, "_on_statement")
	
	$Auto.connect("pressed", self, "on_auto")
	$AutoTimer.connect("timeout", self, "on_auto_loop")
	
	$Skip.connect("pressed", self, "on_skip")
	$SkipTimer.connect("timeout", self, "on_skip_loop")
	$Skip.disabled = true

	$History.disabled = true
	$History.connect("pressed", Screens, "history_menu")
	
	$QSave.connect("pressed", self, "_on_qsave")
	$QLoad.connect("pressed",self, "_on_qload")
	
	$Save.connect("pressed", self, "full_save")
	$Load.connect("pressed", Screens, "load_menu")
	
	$Back.disabled = true
	$Back.connect("pressed", Ren, "rollback")

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

func _on_statement(type, kwargs):
	$Skip.disabled = not(type in skip_types)
	$Auto.disabled = not(type in skip_types)
	$History.disabled = Ren.history.empty()

func on_auto():
	if not $AutoTimer.is_stopped():
		$AutoTimer.stop()
		Ren.skip_auto = false
		return
	
	Ren.skip_auto = true
	$AutoTimer.start()

func on_auto_loop():
	if Ren.current_statement.type in skip_types:
		Ren.exit_statement()

	else:
		$AutoTimer.stop()


func stop_skip():
	$SkipTimer.stop()
	$InfoAnim.stop()
	$InfoAnim/Panel.hide()

func on_skip():
	if not $SkipTimer.is_stopped():
		stop_skip()
		Ren.skip_auto = false
		return

	Ren.skip_auto = true
	$SkipTimer.start()
	$InfoAnim.play("Skip")

func on_skip_loop():
	if Ren.current_statement.type in skip_types:
		Ren.exit_statement()
	else:
		stop_skip()

func _input(event):
	if event.is_action_pressed("ren_forward"):
		if Ren.skip_auto:
			$AutoTimer.stop()
			stop_skip()
			Ren.skip_auto = false
	

func full_save():
	var screenshot=get_viewport().get_texture().get_data()
	Screens.save_menu(screenshot)


	
