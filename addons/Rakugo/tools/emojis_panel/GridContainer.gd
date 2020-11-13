tool
extends GridContainer



func _on_filter_changed(text: String):
	if text == "":
		for ch in get_children():
			ch.visible = true
	else:
		for ch in get_children():
			if ch.name.find(text) != -1:
				ch.visible = true
			else:
				ch.visible = false
