extends GDScriptDialog

signal rightaway
signal later

func start(node_name, dialog_name):
	if !check_dialog(node_name, dialog_name, "start"):
		return
	
	dialog_init = true
	
	if next_state():
		show("bg lecturehall")
		# play music "illurock.opus"
		say({
		"what":
			"It's only when I hear the sounds of shuffling feet and supplies being put away that I realize that the lecture's over."
		})

	if next_state():
		say({
		"what":
		"Professor Eileen's lectures are usually interesting, but today I just couldn't concentrate on it."
		})

	if next_state():
		say({
		"what":
		"I've had a lot of other thoughts on my mind...thoughts that culminate in a question."
		})

	if next_state():
		say({
			"what":
			 "It's a question that I've been meaning to ask a certain someone."
		})

	if next_state():
		show("bg uni")
		say({
		"what":
			"When we come out of the university, I spot her right away."
		})

	if next_state():
		show("sylvie green normal")
		say({
		"what":
			"I've known [s.name] since we were kids. She's got a big heart and she's always been a good friend to me."
		})

	if next_state():
		say({
		"what":
			"But recently... I've felt that I want something more."
		})

	if next_state():
		say({
		"what":
		"But recently... I've felt that I want something more."
		})

	if next_state():
		say({
		"what":
			"More than just talking, more than just walking home together when our classes end."
		})

	if next_state():
		menu({
		"what":
			"As soon as she catches my eye, I decide...",
		"choices":
			{
				"To ask her right away.": "rightaway",
				"To ask her later.": "later"
			}
		})


func _on_start_later():
	jump("Start", "later", "later")


func _on_start_rightaway():
	jump("Start", "rightaway", "rightaway")
