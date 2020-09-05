extends Control


signal quick_button_press(quick_action)

func _ready():
	connect_buttons()

func connect_buttons():
	for qb in get_tree().get_nodes_in_group("quick_button"):
		qb.connect("quick_button_pressed", self, "_on_quick_button_pressed")


func _on_quick_button_pressed(quick_action):
	emit_signal("quick_button_press", quick_action)
