extends HBoxContainer

onready var Screens = get_node("../../Screens")
var save_error_msg = "[color=red]Error saving Game[/color]"
var load_error_msg = "[color=red]Error loading Game[/color]"

func _ready():
	Ren.connect("exec_statement", self, "_on_statement")
	$Auto.connect("pressed", self, "on_auto")
	
	$Skip.connect("pressed", self, "on_skip")
	$Skip.disabled = true

	Ren.skip_timer.connect("stop_loop", self, "on_stop_loop")
	Ren.auto_timer.connect("stop_loop", self, "on_stop_loop")

	$History.connect("pressed", Screens, "history_menu")
	$History.disabled = true
	
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
	$Skip.disabled = !Ren.can_skip()
	$Auto.disabled = !Ren.can_auto()
	$History.disabled = Ren.current_id == 0
	$QLoad.disabled = !Ren.can_qload()

func on_auto():
	$Skip.pressed = false
	if not Ren.auto_timer.run():
		on_stop_loop()
		return
	
	$InfoAnim.play("Auto")

func on_stop_loop():
	$Auto.pressed = false
	$Skip.pressed = false
	$InfoAnim.stop()
	$InfoAnim/Panel.hide()

func on_skip():
	$Auto.pressed = false
	if not Ren.skip_timer.run():
		on_stop_loop()
		return

	$InfoAnim.play("Skip")

func full_save():
	var screenshot = get_viewport().get_texture().get_data()
	Screens.save_menu(screenshot)


	
