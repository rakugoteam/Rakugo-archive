extends BoxContainer

export(String) var kind = "vertical"
export(PackedScene) var ChoiceButton

func _ready():
	Ren.connect("exec_statement", self, "_on_statement")

func _on_statement(type, kwargs):
	if type != "menu":
		get_parent().hide()
		return

	if kwargs["mkind"] != kind:
		get_parent().hide()
		return
		
	get_parent().show()

	for ch in get_children():
		ch.queue_free()

	var i = 0
	var choices = Ren.menu_node.choices_labels
	for ch in choices:
		var ch_button = ChoiceButton.instance()
		add_child(ch_button)
		ch_button.label.bbcode_text = "[center]" + ch + "[/center]"
		ch_button.id = i
		print("create button (", ch, ") with id : ", i)
		i += 1

	get_parent().show()

