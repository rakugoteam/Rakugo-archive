extends Control

onready var in_game_gui = get_node("/root/Window/InGameGUI")

var current_node = self

func _ready():
	connect("visibility_changed", self, "_on_Screens_visibility_changed")

func show_page(node):
	if current_node != self:
		current_node.hide()
	current_node = node
	node.show()

func save_menu(screenshot):
	show_page($SlotBox)
	$SlotBox/Title.text="Save"
	$SlotBox.savebox()
	$SlotBox.screenshot=screenshot
	show()

func load_menu():
	show_page($SlotBox)
	$SlotBox/Title.text="Load"
	$SlotBox.loadbox()
	show()

func history_menu():
	show_page($HistoryBox)
	show()

func _on_Screens_visibility_changed():
	if visible:
		get_tree().paused = true
		in_game_gui.hide()
	else:
		get_tree().paused = false
		in_game_gui.show()

func _on_Return_pressed():
	hide()

func _on_Load_pressed():
	load_menu()

func in_game():
	$Navigation/VBoxContainer/Start.hide()
	$Navigation/VBoxContainer/Continue.hide()
	$Navigation/VBoxContainer/Return.show()
	$Navigation/VBoxContainer/Save.show()
	$Navigation/VBoxContainer/History.show()
	$Navigation/VBoxContainer/Quests.show()

func _on_Start_pressed():
	hide()
	in_game()
	Ren.start()

func _on_History_pressed():
	history_menu()

func _on_Continue_pressed():
	if !Ren.loadfile():
		return
	in_game()
	hide()

func _on_Quests_pressed():
	show_page($QuestsBox)
	show()

# if press "yes" on quit page
func _on_Yes_pressed():
	get_tree().quit()

func _on_Quit_pressed():
	show_page($QuitBox)
