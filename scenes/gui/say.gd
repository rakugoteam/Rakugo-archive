## This is in-game gui example for Ren API ##
## version: 0.1.0 ##
## License MIT ##

extends Container

onready var ren	= get_node("/root/Window")

onready var NameLabel = get_node("VBox/Label")
onready var DialogText = get_node("VBox/Dialog")
onready var CharacterAvatar = get_node("CharaterAvatar")
onready var InputLine = get_node("VBox/Input")
onready var BBCode = get_node("VBox/BBCode") # use to parse bbcode for InputLine

var avatar_path = ""
var avatar
var input_placeholder = ""

func _ready():
	ren.connect("enter_statement", self, "_on_statement")
	InputLine.hide()

func _on_input(event):
	if event.is_action_released("ren_rollforward"):
		ren.emit_signal("exit_statement", {})

func _on_enter(text):
	var final_value = input_placeholder
	if not text.empty():
		final_value = InputLine.get_text()
	
	ren.emit_signal("exit_statement", {"value":final_value})

func _on_statement(type, kwargs):
	if not type in ["say", "input"]:
		return

	if "how" in kwargs:
		NameLabel.set_bbcode(kwargs.how)
	
	if "what" in kwargs:
		DialogText.set_bbcode(kwargs.what)
	
	if "avatar" in kwargs:
		if avatar_path != kwargs.avatar:
			if avatar != null:
				avatar.free()
				
		if kwargs.avatar != null:
			avatar_path = kwargs.avatar
			avatar = load(kwargs.avatar).instance()
			CharacterAvatar.add_child(avatar) 
	
	if type != "input":
		if InputLine.is_connected("text_entered", self , "_on_enter"):
			InputLine.disconnect("text_entered", self , "_on_enter")

		if not is_connected("input_event", self, "_on_input"):
			connect("input_event", self, "_on_input")

		InputLine.hide()
		return
	
	if is_connected("input_event", self, "_on_input"):
		disconnect("input_event", self, "_on_input")

	if "value" in kwargs:
		BBCode.set_bbcode(kwargs.value)
		input_placeholder = BBCode.get_text()
		InputLine.set_placeholder(input_placeholder)
	
	InputLine.show()
	InputLine.grab_focus()
	InputLine.connect("text_entered", self , "_on_enter")
