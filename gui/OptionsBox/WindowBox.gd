extends CollapsedList

func _ready() -> void:
	connect("visibility_changed", self, "_on_visibility_changed")

func _on_visibility_changed() -> void:
	if not visible:
		return
		
	current_choice_id = settings.get_window_type_id()
		
	update_label()

func update_label(choice : String = options_list[current_choice_id]) -> void:
	.update_label(choice)
	settings.temp_window_type_id = current_choice_id
	
	if settings.temp_window_type_id == 1: # if fullscreen 
		settings.temp_window_size = OS.get_screen_size()
		
	settings.apply()