## This is in-game gui example for Ren API ##
## version: 0.1.0 ##
## License MIT ##

extends Container

onready var ren	= get_node("/root/Window")

onready var NameLabel = get_node("VBox/Label")
onready var DialogText = get_node("VBox/Dialog")
onready var CharacterAvatar = get_node("CharaterAvatar")
onready var InputLine = get_node("VBox/Input")

var avatar_path = ""
var avatar
var statement_id

func _ready():
	ren.connect("use_statement", self, "_on_statement")
	InputLine.hide()

func _on_input(event):
	if event.is_action_released("ren_rollforward"):
		ren.emit_signal("next_statement", statement_id, {})

func _on_enter(text):
	var input_value = ""
	if text != "":
		input_value = InputLine.get_placeholder()
	else:
		input_value = InputLine.get_text()
	
	ren.emit_signal("next_statement", statement_id, {"input_value":input_value})

func _on_statement(type,  id,  kwargs):
	if not type in ["say", "input"]:
		return
		
	statement_id = id

	if "how" in kwargs:
		NameLabel.set_text(kwargs.how)
	
	if "what" in kwargs:
		DialogText.set_text(kwargs.what)
	
	if "avtar" in kwargs:
		if avatar_path != kwargs.avatr:
			if avatar != null:
				avatar.free()
				
		if kwargs.avatr != null:
			avatar_path = kwargs.avatar
			avatar = load(kwargs.avatar).instance()
			CharacterAvatar.add(avatar) 
	
	if type != "input":
		if InputLine.is_connected("text_entered", self , "_on_enter"):
			InputLine.disconnect("text_entered", self , "_on_enter")

		if not is_connect("input_event", self, "_on_input"):
			connect("input_event", self, "_on_input")

		InputLine.hide()
		return
	
	if is_connect("input_event", self, "_on_input"):
		disconnect("input_event", self, "_on_input")

	if "temp" in kwargs:
		InputLine.set_placeholder(kwargs.temp)
	
	InputLine.show()
	InputLine.grab_focus()
	InputLine.connect("text_entered", self , "_on_enter")
