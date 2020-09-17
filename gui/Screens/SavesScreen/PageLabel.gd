extends LineEdit

var current_page = 0

func _on_page_changed(page):
	current_page = page
	if page in settings.saves_page_names:
		text = settings.saves_page_names[page]
	else:
		match page:
			"quick":
				self.editable = false
				text = "Quick saves"
			"auto":
				self.editable = false
				text = "Automatic saves"
			"quick":
				self.editable = false
				text = "Quick saves"
			"auto":
				self.editable = false
				text = "Automatic saves"
			_:
				text = "Page " + str(page)


func _on_text_changed(new_text):
	settings.saves_page_names[current_page] = new_text
