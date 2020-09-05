extends RakugoControl


export onready var unpause_timer: Timer = $UnpauseTimer

signal show_menu(menu, game_started)

func _ready():
	if Engine.editor_hint:
		return

	get_tree().set_auto_accept_quit(false)

	#qno_button.connect("pressed", self, "_on_Return_pressed")

	Rakugo.connect("game_ended", self, "_on_game_end")

func _on_nav_button_press(nav):
	match nav:
		"start":
			hide()
			in_game()
			Rakugo.start()
			Rakugo.emit_signal("begin")
		"continue":
			if !Rakugo.loadfile("auto"):
				return
			in_game()
			hide()
		"save":
			save_menu(get_screenshot())
		"load":
			load_menu()
		"history":
			show_page(nav)
		"preferences":
			show_page(nav)
		"about":
			show_page(nav)
		"main_menu":
			if Rakugo.started:
				Rakugo.end_game()
				show_page(nav)
			else:
				show_page(nav)
		"return":
			if Rakugo.started:
				hide()
			else:
				show_page(nav)
		"quit":
			$QuitScreen.visible = true
		

const page_action_index:Dictionary = {
	'main_menu':0,
	'return':0,
	'about':1,
	'help':1,
	'history':2,
	'preferences':3,
	'save':4,
	'load':4
}

func show_page(action):
	emit_signal("show_menu", action, Rakugo.started)
	$SubMenus.current_tab = page_action_index[action]
	show()

func save_menu(screenshot):
	$SubMenus/SavesSlotScreen.save_mode = true
	$SubMenus/SavesSlotScreen.screenshot = screenshot
	show_page("save")


func load_menu():
	$SubMenus/SavesSlotScreen.save_mode = false
	show_page("load")

func _on_visibility_changed():
	if visible:
		get_tree().paused = true
		Window.InGameGUI.hide()
	else:
		Window.InGameGUI.show()
		unpause_timer.start()
		yield(unpause_timer, "timeout")
		get_tree().paused = false


# Unused at this point I think
func _on_Return_pressed():
	if visible:
		hide()
		unpause_timer.start()
		yield(unpause_timer, "timeout")
		return


func in_game():
	#scrollbar.show()
	pass


func _on_game_end():
	#scrollbar.hide()
	show()

func get_screenshot():
	var screenshot:Image = Window.viewport.get_texture().get_data()
	screenshot.flip_y()
	return screenshot

func _screenshot_on_input(event):
	if !event.is_action_pressed("rakugo_screenshot"):
		return

	var dir = Directory.new()
	var screenshots_dir = "user://screenshots"

	if !dir.dir_exists(screenshots_dir):
		dir.make_dir(screenshots_dir)

	var s = Rakugo.get_datetime_str().replace(":", " ")
	get_screenshot().save_png(screenshots_dir.plus_file(s + '.png'))


func _input(event):
	if Engine.editor_hint:
		return

	if event.is_action_pressed("ui_cancel"):
		if visible:
			_on_nav_button_press("return")

		return

	if not get_focus_owner() and Rakugo.can_alphanumeric:
		_screenshot_on_input(event)


func _on_load_file():
	in_game()
	hide()



func _on_SavesSlotScreen_mode_changed(save_mode):
	if save_mode:
		emit_signal("show_menu", "save", Rakugo.started)
	else:
		emit_signal("show_menu", "load", Rakugo.started)
