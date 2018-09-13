extends HBoxContainer

onready var Screens = get_node("../../Screens")
var save_error_msg = "[color=red]Error saving Game[/color]"
var load_error_msg = "[color=red]Error loading Game[/color]"

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
	$Quests.connect("pressed", Screens, "_on_Quests_pressed")

func _on_qsave():
	if Ren.savefile():
		$InfoAnim.play("Saved")
	
	else:
		$InfoAnim/Panel/Label.bbcode_text = save_error_msg
		$InfoAnim.play("GeneralNotif")


func _on_qload():
	if Ren.loadfile():
		$InfoAnim.play("Loaded")
		Ren.story_step()
	
	else:
		$InfoAnim/Panel/Label.bbcode_text = load_error_msg
		$InfoAnim.play("GeneralNotif")

func _on_statement(type, kwargs):
	$Skip.disabled = Ren.cant_skip()
	$Auto.disabled = Ren.cant_auto()
	$History.disabled = Ren.current_id == 0
	$QLoad.disabled = Ren.cant_qload()

func on_auto():
	if not $AutoTimer.is_stopped():
		$AutoTimer.stop()
		Ren.skip_auto = false
		return
	
	Ren.skip_auto = true
	$AutoTimer.start()

func on_auto_loop():
	if Ren.current_statement.type in Ren.skip_types:
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
	if not Ren.current_statement_in_global_history():
		stop_skip()

	if Ren.current_statement.type in Ren.skip_types:
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
	var screenshot = get_viewport().get_texture().get_data()
	Screens.save_menu(screenshot)


	
