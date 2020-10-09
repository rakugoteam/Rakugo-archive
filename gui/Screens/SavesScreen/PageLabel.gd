extends LineEdit

var current_page = 0

func _on_page_changed():
	current_page = Settings.get('rakugo/saves/current_page')
	var saves_page_names = Settings.get('rakugo/saves/page_names', {})
	if current_page in saves_page_names:
		text = saves_page_names[current_page]
	else:
		match current_page:
			-1:
				self.editable = false
				text = "Quick saves"
			-2:
				self.editable = false
				text = "Automatic saves"
			_:
				text = "Page " + str(current_page)


func _on_text_changed(new_text):
	var saves_page_names = Settings.get('rakugo/saves/page_names', {})
	saves_page_names[current_page] = new_text
