extends VBoxContainer

export(PackedScene) var ChoiceButton

func _ready():
	Ren.connect("enter_statement", self, "_on_statement", [], CONNECT_PERSIST)

func _on_statement(id, type, kwargs):
	if type != "menu":
		hide()
		return

		ch.queue_free() #free causes problem in VS

	var i = 0
	var choices = Ren.current_menu.choices_labels
	for ch in choices:
		var ch_button = ChoiceButton.instance()
		add_child(ch_button)
		ch_button.label.bbcode_text = "[center]" + ch + "[/center]"
		ch_button.id = i
		print("create button (", ch, ") with id : ", i)
		i += 1

	show()

