## This is in-game gui example for Ren API ##
## version: 0.1.0 ##
## License MIT ##

extends Container

onready var ren	= get_node("/root/Window")

onready var NameLabel = get_node("VBox/Label")
onready var DialogText = get_node("VBox/Dialog")
onready var CharacterAvatar = get_node("CharaterAvatar")

var avatar_path = ""
var avatar

func _ready():
	ren.connect("enter_statement", self, "_on_statement")
	
func _on_input(event):
	if event.is_action_released("ren_rollforward"):
		ren.emit_signal("exit_statement", {})

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
		if not is_connected("input_event", self, "_on_input"):
			connect("input_event", self, "_on_input")

		return
	
