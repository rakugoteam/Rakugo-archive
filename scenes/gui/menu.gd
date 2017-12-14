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
		ch.disconnect("pressed", self, "_on_button_pressed")
		ch.free()
	
	var i = 0
	var choices = ren.current_menu.choices_labels
	for ch in choices:
		var ch_button = ChoiceButton.instance()
		add_child(ch_button)
		var text = str((ch_button.get_path())) + "/RichTextLabel"
		get_node(text).set_bbcode("[center]" + ch + "[/center]")
		ch_button.connect("pressed", self, "_on_button_pressed", [i])
		print("create button (", ch, ") with id : ", i)
		i += 1
	
	show()

func _on_button_pressed(id):
	print("final_choice ", id)
	ren.emit_signal("enter_block", {"final_choice":id})
