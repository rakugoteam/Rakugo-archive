extends Control

var menu_names:Dictionary = {
	"history":"History",
	"save":"Save",
	"load":"Load",
	"preferences":"Preferences",
	"about":"About",
	"help":"Help"
}

func _on_show_menu(menu, game_started):
	if not menu in menu_names:
		visible = false
		return

	visible = true
	$"../ReturnButton".visible = true

	for nb in get_tree().get_nodes_in_group("nav_button"):
		if nb.text == menu_names[menu]:
			nb.pressed = true

		if "nav_button_main_menu" in nb.get_groups():
			nb.visible = not game_started

		if "nav_button_game" in nb.get_groups():
			nb.visible = game_started


	$CurrentSubMenu.text = menu_names[menu]
