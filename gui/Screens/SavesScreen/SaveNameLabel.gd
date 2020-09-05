extends Label

export var hide_default_name:bool = true
export var display_placeholder:bool = false

func _on_set_save_name(save_name):
	if hide_default_name and save_name == "save":
		save_name = ""
	if display_placeholder and not save_name:
		save_name = "Unnamed"
	if save_name == "empty":
		save_name = "New Save"
	text = save_name
