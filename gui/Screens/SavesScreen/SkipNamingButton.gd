extends CheckButton


func _ready():
	pressed = Settings.get('rakugo/saves/skip_naming', true)


func _on_save_mode_changed(save_mode):
	visible = save_mode

func _on_toggled(button_pressed):
	Settings.set('rakugo/saves/skip_naming', button_pressed)
