extends GDScriptDialog

var s
var m

func _init_marry():
	s = get_var("s")
	m = get_var("m")

func marry(node_name, dialog_name):
	if !check_dialog(node_name, dialog_name, "marry"):
		return

	if !dialog_init:
		_init_marry()
		dialog_init = true

	if next_state():
		say({
		"what": "{center}And so, we become a visual novel creating duo.{/center}",
		"kind": "fullscreen"
			})

	if next_state():
		show("bg club")
		say({
		"what": "Over the years, we make lots of games and have a lot of fun making them."
		})

	if next_state():
		if get_value("book"):
			say({"what":
				"Our first game is based on one of Sylvie's ideas,"
			+ " but afterwards I get to come up with stories of my own, too."
			})

	if next_state():
		say({"what":
			"We take turns coming up with stories and"
			+" characters and support each other to make some great games!"
			})

	if next_state():
		say({"what": "And one day..."})

	if next_state():
		show("sylvie blue normal")
		s.say({"what": "Hey..."})

	if next_state():
		m.say({"what": "Yes?"})

	if next_state():
		show("show sylvie blue giggle")
		s.say({"what": "Will you marry me?"})

	if next_state():
		m.say({"what": "What? Where did this come from?"})

	if next_state():
		show("sylvie blue surprised")
		s.say({"what": "Come on, how long have we been dating?"})

	if next_state():
		m.say({"what": "A while..."})

	if next_state():
		show("sylvie blue smile")
		s.say({"what": "These last few years we've been making visual novels together, spending time together, helping each other..."})

	if next_state():
		s.say({"what": "I've gotten to know you and care about you better than anyone else. And I think the same goes for you, right?"})

	if next_state():
		m.say({"what":"[s.name]"})

	if next_state():
		show("sylvie blue giggle")
		s.say({"what": "But I know you're the indecisive type. If I held back, who knows when you'd propose?"})

	if next_state():
		show("sylvie blue normal")
		s.say({"what": "So will you marry me?"})

	if next_state():
		end_game()
