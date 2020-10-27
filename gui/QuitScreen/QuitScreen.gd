extends Panel

signal quit_confirm()


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		if visible:
			_on_confirmed()#If the confirmation is already display and the user calls to quit an other time the
		visible = true


func _on_confirmed():
	Rakugo.prepare_quitting()
	get_tree().quit()


func _on_visibility_changed():#Using self connected signal to also handle external use
	if visible:
		Rakugo.StepBlocker.block('quit_screen')
		$QuitConfirmDialog.call_deferred("popup_centered")


func _on_popup_hide():
	visible = false
	_delayed_unblock_stepping()


func _delayed_unblock_stepping():
	yield(get_tree().create_timer(0.1), "timeout")#prevent the input that cancelled quitting to trigger the step
	Rakugo.StepBlocker.unblock('quit_screen')
	
