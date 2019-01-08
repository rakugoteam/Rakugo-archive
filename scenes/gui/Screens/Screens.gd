extends Control

onready var in_game_gui = get_node("/root/Window/InGameGUI")

var current_node = self
var nav_path = "Navigation/ScrollContainer/VBoxContainer/"
func _ready():
	get_tree().set_auto_accept_quit(false)
	connect("visibility_changed", self, "_on_visibility_changed")
	var auto_save_path = str("user://" + Ren.save_folder + "/auto.save")
	if not Ren.file.file_exists(auto_save_path):
		get_node(nav_path + "Continue").hide()

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		_on_Quit_pressed()

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

func _on_visibility_changed():
	if visible:
		get_tree().paused = true
		in_game_gui.hide()
	else:
		get_tree().paused = false
		in_game_gui.show()

## # if press "Return" or "no" on quit page
func _on_Return_pressed():
	if Ren.started:
		hide()
	else:
		current_node.hide()

func _on_Load_pressed():
	load_menu()

func in_game():
	get_node(nav_path + "NewGame").hide()
	get_node(nav_path + "Continue").hide()
	get_node(nav_path + "Return").show()
	get_node(nav_path + "Save").show()
	get_node(nav_path + "History").show()
	get_node(nav_path + "Quests").show()

func _on_NewGame_pressed():
	hide()
	in_game()
	Ren.start()

func _on_History_pressed():
	history_menu()

func _on_Continue_pressed():
	if !Ren.loadfile("auto"):
		return

	in_game()
	hide()

func _on_Quests_pressed():
	show_page($QuestsBox)
	show()

# if press "yes" on quit page
func _on_Yes_pressed():
	if !Ren.savefile("auto"):
		return
		
	get_tree().quit()

func _on_Quit_pressed():
	show_page($QuitBox)
	show()

func _on_Save_pressed():
	hide()
	var screenshot = get_viewport().get_texture().get_data()
	save_menu(screenshot)

func _on_TestNodes_pressed():
	show_page($TestNodes)
	show()

func _on_Options_pressed():
	show_page($OptionsBox)
	show()

func _on_About_pressed():
	show_page($AboutBox)
	show()

func _on_Help_pressed():
	OS.shell_open("https://github.com/jeremi360/Ren/wiki")
