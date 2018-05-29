extends BoxContainer

export(String) var kind = "vertical"
export(PackedScene) var ChoiceButton

func _ready():
	Ren.connect("exec_statement", self, "_on_statement")

func _on_statement(type, kwargs):
	if type != "menu":
		hide()
		return

	if kwargs["mkind"] != kind:
		hide()
		return
		
	show()

	for ch in get_children():
		ch.queue_free() #free causes problem in VS

	var i = 0
	var choices = Ren.menu_node.choices_labels
	for ch in choices:
		var ch_button = ChoiceButton.instance()
		add_child(ch_button)
		ch_button.label.bbcode_text = "[center]" + ch + "[/center]"
		ch_button.id = i
		print("create button (", ch, ") with id : ", i)
		i += 1

	show()

