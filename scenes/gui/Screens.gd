extends Control

onready var in_game_gui = get_node("/root/Window/InGameGUI")


func _ready():
	connect("visibility_changed", self, "_on_Screens_visibility_changed")
	
	
func save_menu(screenshot):
	show()
	$SlotBox/Title.text="Save"
	$SlotBox.show()
	$SlotBox.savebox()
	$SlotBox.screenshot=screenshot

func load_menu():
	show()
	$SlotBox/Title.text="Load"
	$SlotBox.show()
	$SlotBox.loadbox()

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
	$Navigation/Return.show()
	Ren.start()
	
