extends GDScriptDialog


func later(node_name, dialog_name):
	if !check_dialog(node_name, dialog_name, "later"):
		return
	
	dialog_init = true

	if next_state():
		say({"what":
				"I can't get up the nerve to ask right now."
				+"{nl}With a gulp, I decide to ask her later."
			})

	if next_state():
		# scene black
		# with dissolve
		say({"what": "But I'm an indecisive person."})

	if next_state():
		say({"what": "I couldn't ask her that day and I end up never being able to ask her."})

	if next_state():
		say({"what": "I guess I'll never know the answer to my question now..."})

	if next_state():
		say({
			"what": "{center}{b}Bad Ending{/b}{/center}.",
			"kind":"fullscreen"
		})

	if next_state():
		end_game()
