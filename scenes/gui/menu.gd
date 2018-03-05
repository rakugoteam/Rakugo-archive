## This is in-game gui example for Ren API ##
## version: 0.5.0 ##
## License MIT ##
extends VBoxContainer


onready var ChoiceButton = preload("res://scenes/gui/ChoiceButton.tscn")

func _ready():
	Ren.connect("enter_statement", self, "_on_statement")

func _on_statement(id, type, kwargs):
	if type != "menu":
		hide()
		return
	
	for ch in get_children():
		if ch.is_connected("pressed", self, "_on_button_pressed"):
			ch.disconnect("pressed", self, "_on_button_pressed")
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

