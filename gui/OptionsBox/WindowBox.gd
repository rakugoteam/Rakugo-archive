extends "CollapsedList.gd"

func _ready():
	options_list = [
		"Windowed",
		"Fullscreen",
		"Maximized"
	]

	connect("visibility_changed", self, "_on_visibility_changed")

func _on_visibility_changed():
	if not visible:
		return
		
	current_choice_id = settings.get_window_type_id()
		
	update_label()


func update_label(choice = options_list[current_choice_id]):
	.update_label(choice)
	settings.temp_window_type_id = current_choice_id