extends Control

onready var in_game_gui = get_node("../InGameGUI")
onready var ren = get_node("/root/Window")

func _ready():
	pass
	
	
func save_menu(screenshot):
	show()
	$SlotBox/Title.text="Save"
	$SlotBox.show()
	$SlotBox.savebox()
	$SlotBox.screenshot=screenshot
	$Navigation/Return.show()

func load_menu():
	show()
	$SlotBox/Title.text="Load"
	$SlotBox.show()
	$SlotBox.loadbox()
	$Navigation/Return.show()

func _on_Screens_visibility_changed():
	if visible:
		in_game_gui.hide()
	else:
		in_game_gui.show()


func _on_Return_pressed():
	$Navigation/Return.hide()
	hide()


func _on_Load_pressed():
	load_menu()


func _on_Start_pressed():
	hide()
	$Navigation/Start.hide()
	$Navigation/Return.show()
	ren.start()
	
