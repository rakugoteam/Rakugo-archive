extends Panel

signal quit_confirm()


func _on_confirmed():
	emit_signal("quit_confirm")


func _on_custom_action(action):
	print(action)
	if action == "cancel":
		visible  = false


func _on_visibility_changed():
	$QuitConfirmDialog.popup()
