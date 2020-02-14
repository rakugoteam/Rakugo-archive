extends GDScriptDialog

signal statements
signal markups
signal vars
signal nodes

var s:CharacterObject

func _init_start():
	s = get_var("s")

func start(node_name, dialog_name):
	if !check_dialog(node_name, dialog_name, "start"):
		return
	
	if !dialog_init:
		_init_start()
		dialog_init = true
	
	if next_state():
		show("sylvie green smile")
		show("bg uni")
		s.say({
			"what":
				"Hi Developer! My name is [s.name]."
				+ " Welcome in Rakugo Tutorial."
		})
	
	if next_state():
		s.menu({
			"what":
				"What do you want to learn today?",
			"node": self,
			"choices":
				{
					"Dialog Statements": "statements",
					"Text Markups": "markups",
					"Rakugo Vars": "vars",
					"Rakugo Nodes": "nodes"
				}
		})
