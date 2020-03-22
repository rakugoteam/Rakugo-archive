extends GDScriptDialog

var s
var m

func _init_game():
	s = get_var("s")
	m = get_var("m")

func game(node_name, dialog_name):
	if !check_dialog(node_name, dialog_name, "game"):
		return
	
	if !dialog_init:
		_init_game()
		dialog_init = true

	if next_state():
		define("book", false)
		m.say({
		"what":
			"It's a kind of videogame you can play on your computer or a console."
		})

	if next_state():
		m.say({
		"what":
			"Visual novels tell a story with pictures and music."
		})

	if next_state():
		m.say({
		"what":
			"Sometimes, you also get to make choices that affect the outcome of the story."
		})

	if next_state():
		s.say({
		"what":
			"So it's like those choose-your-adventure books?"
		})

	if next_state():
		m.say({
		"what":
			"Exactly! I've got lots of different ideas that I think would work."
		})

	if next_state():
		m.say({
		"what":
			"And I thought maybe you could help me...since I know how you like to draw."
		})

	if next_state():
		show("sylvie green normal")
		s.say({
		"what":
			"Well, sure! I can try. I just hope I don't disappoint you."
		})

	if next_state():
		m.say({
		"what":
			"You know you could never disappoint me, [s.name]."
		})

	if next_state():
		jump("Start", "marry", "marry")
