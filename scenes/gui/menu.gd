extends VBoxContainer

onready var ren = get_node("/root/Window")
onready var ChoiceButton = preload("res://scenes/gui/ChoiceButton.tscn")

func _ready():
	ren.connect("enter_statement", self, "_on_statement")

func _on_statement(type, kwargs):
	if type != "menu":
		hide()
		return
	
	for ch in get_children():
		if ch.is_connected("pressed", self, "_on_button_pressed"):
			ch.disconnect("pressed", self, "_on_button_pressed")
		ch.queue_free() #free causes problem in VS
	
	var i = 0
	var choices = ren.current_menu.choices_labels
	for ch in choices:
		var ch_button = ChoiceButton.instance()
		add_child(ch_button)
		ch_button.label.bbcode_text = "[center]" + ch + "[/center]"
		ch_button.id = i
		print("create button (", ch, ") with id : ", i)
		i += 1
	
	show()

