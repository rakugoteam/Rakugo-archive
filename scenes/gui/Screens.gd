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
	$SlotBox/Title.text = "Save"
	$SlotBox.savebox()
	$SlotBox.screenshot = screenshot
	show()

func load_menu():
	show_page($SlotBox)
	$SlotBox/Title.text = "Load"
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
	var path = "Navigation/ScrollContainer/VBoxContainer/"
	get_node(path + "NewGame").hide()
	get_node(path + "Continue").hide()
	get_node(path + "Return").show()
	get_node(path + "Save").show()
	get_node(path + "History").show()
	get_node(path + "Quests").show()

# now is connected to $NewGame
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


func _on_Save_pressed():
	hide()
	var screenshot = get_viewport().get_texture().get_data()
	save_menu(screenshot)


func _on_TestNodes_pressed():
	show_page($TestNodes)
