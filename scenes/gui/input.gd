extends VBoxContainer

onready var ren	= get_node("/root/Window")

onready var InputLine = get_node("Input")
onready var BBCode = get_node("BBCode") # use to parse bbcode for InputLine
var input_placeholder = ""

func _ready():
	ren.connect("use_statement", self, "_on_statement")
	InputLine.hide()

func _on_enter(text):
	var final_value = input_placeholder
	if not text.empty():
		final_value = InputLine.get_text()
	
	ren.emit_signal("next_statement", {"value":final_value})

func _on_statement(type, kwargs):
	if type != "input":
		if InputLine.is_connected("text_entered", self , "_on_enter"):
			InputLine.disconnect("text_entered", self , "_on_enter")

		InputLine.hide()
		return

	if "value" in kwargs:
		BBCode.set_bbcode(kwargs.value)
		input_placeholder = BBCode.get_text()
		InputLine.set_placeholder(input_placeholder)
	
	InputLine.show()
	InputLine.grab_focus()
	InputLine.connect("text_entered", self , "_on_enter")