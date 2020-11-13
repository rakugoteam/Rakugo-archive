extends Control

var hide_toggle = false

func _input(event):
	if visible:
		if event.is_action_pressed("ui_cancel"):
			Window.Screens.call_deferred('_on_nav_button_press', "save")
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
		if event.is_action_pressed("rakugo_hide_ui"):
			hide()
		if event.is_action_pressed("rakugo_hide_ui_toggle"):
			hide_toggle = true
			hide()
	elif Window.get_current_ui() == self:
		if event.is_action_released("rakugo_hide_ui"):
			hide_toggle = false
			show()
		if hide_toggle and event.is_action_pressed("rakugo_hide_ui_toggle"):
			hide_toggle = false
			show()


func _gui_input(event):
	if event.is_action_pressed("ui_left_click"):
		Rakugo.story_step()


func _on_quick_button_press(quick_action):
	match quick_action:
		"hide":
			hide_toggle = true
			hide()
		"skip":
			if Rakugo.skipping:
				Rakugo.deactivate_skipping()
			else:
				Rakugo.activate_skipping()
		_:
			Window.Screens._on_nav_button_press(quick_action)
