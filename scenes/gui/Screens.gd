extends Control

onready var in_game_gui = get_node("/root/Window/InGameGUI")

export(String) var first_dialog = ""
export(String) var first_state = ""
var current_node = self

func _ready():
	connect("visibility_changed", self, "_on_Screens_visibility_changed")
	
func save_menu(screenshot):
	if current_node != self:
		current_node.hide()
	current_node = $SlotBox
	show()
	$SlotBox/Title.text="Save"
	$SlotBox.show()
	$SlotBox.savebox()
	$SlotBox.screenshot=screenshot

func load_menu():
	if current_node != self:
		current_node.hide()
	current_node = $SlotBox
	show()
	$SlotBox/Title.text="Load"
	$SlotBox.show()
	$SlotBox.loadbox()

func history_menu():
	if current_node != self:
		current_node.hide()
	current_node = $HistoryBox
	show()
	$HistoryBox.show()

func _on_Screens_visibility_changed():
	if visible:
		in_game_gui.hide()
	else:
		in_game_gui.show()


func _on_Return_pressed():
	hide()


func _on_Load_pressed():
	load_menu()


func _on_Start_pressed():
	hide()
	$Navigation/VBoxContainer/Start.hide()
	$Navigation/VBoxContainer/Return.show()
	$Navigation/VBoxContainer/Save.show()
	$Navigation/VBoxContainer/History.show()
	Ren.start()


func _on_History_pressed():
	history_menu()


func _on_Continue_pressed():
	if !Ren.loadfile():
		return
	$Navigation/VBoxContainer/Continue.hide()
	hide()
	Ren.story_step()
