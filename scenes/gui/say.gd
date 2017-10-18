## This is in-game gui example for Ren API ##
## version: 0.1.0 ##
## License MIT ##

extends Container

onready var ren	= get_node("/root/Window")

onready var NameLabel	= get_node("VBox/NameBox/Label")
onready var DialogText	= get_node("VBox/Dialog")


func _ready():
	connect("input_event", self, "_on_input")
	ren.connect("use_statement", self, "_on_say")

func _on_input(event):
	if event.is_action_released("ren_rollforward"):
		ren.emit_signal("next_statement")

func _on_say(type,  id,  kwargs):
	if type != "say":
		return

	if "how" in kwargs:
		NameLabel.set_text(kwargs.how)
	
	if "what" in kwargs:
		DialogText.set_text(kwargs.what)
