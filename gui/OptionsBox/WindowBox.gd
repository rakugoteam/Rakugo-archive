extends CollapsedList

func _ready() -> void:
	settings.connect("window_type_changed", self, "_on_window_type_changed")


func _process(delta: float) -> void:
	_on_window_type_changed(settings.get_window_type_id())


func _on_window_type_changed(id: int) -> void:
	current_choice_id = id
	update_label(options_list[id], false)


func update_label(choice: String = options_list[current_choice_id], apply: bool = true) -> void:
	.update_label(choice)
	
	if not apply:
		return
	
	settings.temp_window_type_id = current_choice_id
	
	if settings.temp_window_type_id == 1: # if fullscreen 
		settings.temp_window_size = OS.get_screen_size()
		
	settings.apply()
