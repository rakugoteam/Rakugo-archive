extends GDScriptDialog

func some_dialog(node_name, dialog_name):
	var cd = check_dialog(node_name, dialog_name, "some_dialog")
	
	if not cd:
		return

	if next_state():
		say({"what": "这是中国人"})
#		say({"what": "Hi this is empty Rakugo Template. Please Edit it."})
