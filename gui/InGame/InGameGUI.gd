extends Control

func _input(event):
	if visible:
		if event.is_action_pressed("ui_cancel"):
			Window.Screens._on_nav_button_press("save")
		if event.is_action_pressed("rakugo_skip"):
			Rakugo.activate_skipping()
		if event.is_action_released("rakugo_skip"):
			Rakugo.deactivate_skipping()
		if event.is_action_pressed("rakugo_skip_toggle"):
			if Rakugo.skipping:
				Rakugo.deactivate_skipping()
			else:
				Rakugo.activate_skipping()
		if event.is_action_pressed("rakugo_rollback"):
			Rakugo.rollback(1)
		if event.is_action_pressed("rakugo_rollforward"):
			Rakugo.rollback(-1)


func _gui_input(event):
	if event.is_action_pressed("ui_left_click"):
		Rakugo.story_step()



func _on_quick_button_press(quick_action):
	print(quick_action)
	Window.Screens.show()
	Window.Screens._on_nav_button_press(quick_action)
	pass # Replace with function body.
