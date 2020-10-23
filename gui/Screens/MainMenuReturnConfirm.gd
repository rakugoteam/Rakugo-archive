extends AcceptDialog

signal show_main_menu(nav)

func _ready():
	self.get_ok().text = "Yes"
	self.add_cancel("No")


func _on_show_main_menu_confirm():
	self.popup_centered()


func _on_confirmed():
	Rakugo.reset_game()
	emit_signal("show_main_menu", "main_menu")
	pass # Replace with function body.
