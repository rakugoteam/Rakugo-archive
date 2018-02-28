extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
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
	pass


func _on_Return_pressed():
	$Navigation/Return.hide()
	hide()


func _on_Load_pressed():
	load_menu()


func _on_Start_pressed():
	hide()
