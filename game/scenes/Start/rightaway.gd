extends GDScriptDialog

signal game
signal book

var s
var m

func _init_rightaway():
	s = get_var("s")
	m = get_var("m")


func rightaway(node_name, dialog_name):
	if !check_dialog(node_name, dialog_name, "rightaway"):
		return

	if !dialog_init:
		_init_rightaway()
		dialog_init = true

	if next_state():
		show("sylvie green smile")
		s.say({
		"what":
			"Hi there! How was class?"
		})

	if next_state():
		m.say({
		"what":
			"Good..."
		})

	if next_state():
		say({
		"what":
			"I can't bring myself to admit that it all went in one ear and out the other."
		})

	if next_state():
		m.say({
		"what":
			"Are you going home now? Wanna walk back with me?"
		})

	if next_state():
		s.say({
		"what":
			"Sure!"
		})

	if next_state():
		show("bg meadow")
		say({
		"what":
			"After a short while, we reach the meadows just outside the neighborhood where we both live."
		})

	if next_state():
		say({
		"what":
			"It's a scenic view I've grown used to. Autumn is especially beautiful here."
		})

	if next_state():
		say({
		"what":
			"When we were children, we played in these meadows a lot, so they're full of memories."
		})

	if next_state():
		m.say({
			"what":
				"Hey... Umm..."
		})

	if next_state():
		show("sylvie green smile")
		say({
		"what":
		 "She turns to me and smiles. She looks so welcoming that I feel my nervousness melt away."
		})

	if next_state():
		say({
		"what":
			"I'll ask her...!"
		})

	if next_state():
		m.say({
		"what":
			"Ummm... Will you..."
		})

	if next_state():
		m.say({
		"what":
			"Will you be my artist for a visual novel?"
		})

	if next_state():
		show("sylvie green surprised")
		say({
		"what":
			"Silence."
		})

	if next_state():
		say({
		"what":
			"She looks so shocked that I begin to fear the worst. But then..."
		})

	if next_state():
		show("sylvie green smile")
		s.menu({
		"what":
			"Sure, but what's a \"visual novel?\"",
		"node": self,
		"choices":
			{
				"It's a videogame.": "game",
				"It's an interactive book.": "book"
			}
		})


func _on_rightaway_book():
	jump("Start", "book", "book")


func _on_rightaway_game():
	jump("Start", "game", "game")
