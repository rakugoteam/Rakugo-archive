extends Panel

signal show_menu(menu, game_started)
signal nav_button_press(nav_action)

func _ready():
	connect_buttons()
	disable_continue_button()
	_show_menu("main_menu", Rakugo.started)

func disable_continue_button():
	var auto_save_path = str("user://" + Rakugo.save_folder + "/auto.res")

	if Rakugo.test_save:
		auto_save_path = str("res://" + Rakugo.save_folder + "/auto.tres")

	if not Rakugo.file.file_exists(auto_save_path):
		for n in get_tree().get_nodes_in_group("nav_button_continue"):
			n.disabled = true

func _show_menu(menu, game_started):
	print(Rakugo.started,"  ", game_started)
	emit_signal("show_menu", menu, game_started)

func connect_buttons():
	for nb in get_tree().get_nodes_in_group("nav_button"):
		nb.connect("nav_button_pressed", self, "_on_nav_button_pressed")
	
func _on_nav_button_pressed(nav_action):
	if nav_action != "quit":
		_show_menu(nav_action, Rakugo.started)
	emit_signal("nav_button_press", nav_action)
	pass
