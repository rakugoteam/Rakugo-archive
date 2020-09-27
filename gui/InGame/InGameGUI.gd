extends RakugoControl

func _input(event):
	if visible:
		if event.is_action_pressed("ui_cancel"):
			Window.Screens._on_nav_button_press("save")
		if event.is_action_pressed("rollback"):
			print("Rolling back to id ", Rakugo.StoreManager.current_store_id + 1, " ")
			Rakugo.StoreManager.change_current_stack_index(Rakugo.StoreManager.current_store_id + 1)


func _on_quick_button_press(quick_action):
	print(quick_action)
	Window.Screens.show()
	Window.Screens._on_nav_button_press(quick_action)
	pass # Replace with function body.
