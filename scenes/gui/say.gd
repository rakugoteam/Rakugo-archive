## This is in-game gui example for Ren API ##
## version: 0.3.0 ##
## License MIT ##

extends Panel

onready var ren	= get_node("/root/Window")

onready var timer = $Timer
onready var NameLabel = $VBox/Label
onready var DialogText = $VBox/Dialog
onready var CharacterAvatar = $ViewportContainer/CharaterAvatar

var avatar_path = ""
var avatar
var _type

func _ready():
	ren.connect("enter_statement", self, "_on_statement")
	timer.connect("timeout", self, "_on_timeout")

func _on_timeout():
	set_process_input(_type == "say")
	
func _input(event):
	if event.is_action_released("ren_forward"):
		ren.emit_signal("exit_statement", {})

func _on_statement(type, kwargs):
	set_process_input(false)
	_type = type
	timer.start()
	if not _type in ["say", "input", "menu"]:
		return

	if "how" in kwargs:
		NameLabel.bbcode_text = kwargs.how
	
	if "what" in kwargs:
		DialogText.bbcode_text = kwargs.what
	
	if "avatar" in kwargs:
		if avatar_path != kwargs.avatar:
			if avatar != null:
				avatar.free()
				
		if kwargs.avatar != null:
			avatar_path = kwargs.avatar
			avatar = load(kwargs.avatar).instance()
			CharacterAvatar.add_child(avatar) 

	return
	
