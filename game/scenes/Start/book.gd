extends GDScriptDialog

var s
var m

func _init_book():
	s = get_var("s")
	m = get_var("m")

func book(node_name, dialog_name):
	if !check_dialog(node_name, dialog_name, "book"):
		return

	if !dialog_init:
		_init_book()
		dialog_init = true

	if next_state():
		define("book", true)
		m.say({"what": "It's like an interactive book that you can read on a computer or a console."})

	if next_state():
		show("sylvie green surprised")
		s.say({"what": "Interactive?"})

	if next_state():
		m.say({"what": "You can make choices that lead to different events and endings in the story."})

	if next_state():
		s.say({"what": "So where does the \"visual\" part come in?"})

	if next_state():
		m.say({"what":
			"Visual novels have pictures and even music, "
			+"sound effects, and sometimes voice acting to go along with the text."
			})

	if next_state():
		show("sylvie green smile")
		s.say({"what":
			"I see! That certainly sounds like fun."
			+ " I actually used to make webcomics way back when,"
			+ " so I've got lots of story ideas."
			})

	if next_state():
		m.say({"what":
			"That's great!"
			+ " So...would you be interested in working with me as an artist?"
			})

	if next_state():
		s.say({"what": "I'd love to!"})

	if next_state():
		jump("Start", "marry", "marry")
