extends HBoxContainer

onready var Screens = get_node("../../Screens")
var save_error_msg = "[color=red]Error saving Game[/color]"
var load_error_msg = "[color=red]Error loading Game[/color]"

func _ready():
	Ren.connect("exec_statement", self, "_on_statement")
	
	$Auto.connect("pressed", self, "on_auto")
	
	$Skip.connect("pressed", self, "on_skip")
	# $SkipTimer.connect("timeout", self, "on_skip_loop")
	Ren.skip_timer.connect("stop_loop", self, "stop_skip")
	$Skip.disabled = true

	$History.disabled = true
	$History.connect("pressed", Screens, "history_menu")
	
	$QSave.connect("pressed", self, "_on_qsave")
	$QLoad.connect("pressed",self, "_on_qload")
	
	$Save.connect("pressed", self, "full_save")
	$Load.connect("pressed", Screens, "load_menu")
	$Quests.connect("pressed", Screens, "_on_Quests_pressed")
	$Quit.connect("pressed", Screens, "_on_Quit_pressed")
	$Options.connect("pressed", Screens, "_on_Options_pressed")

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
	Ren.auto_timer.run()

func stop_skip():
	$InfoAnim.stop()
	$InfoAnim/Panel.hide()

func on_skip():
	if not Ren.skip_timer.run():
		stop_skip()
		return

	$InfoAnim.play("Skip")
	
func _input(event):
	if event.is_action_pressed("ren_forward"):
		if Ren.skip_auto:
			Ren.auto_timer.stop()
			stop_skip()
			Ren.skip_auto = false
	

func full_save():
	var screenshot = get_viewport().get_texture().get_data()
	Screens.save_menu(screenshot)


	
