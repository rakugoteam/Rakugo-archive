## This is in-game gui example for Ren API ##
## version: 0.5.0 ##
## License MIT ##

extends Panel

onready var ren	= get_node("/root/Window")

onready var NameLabel = $VBox/Label
onready var DialogText = $VBox/Dialog
onready var CharacterAvatar = $ViewportContainer/CharaterAvatar

var avatar_path = ""
var avatar
var _type
var t
var typing=false

func _ready():
	ren.connect("enter_statement", self, "_on_statement")
	$Timer.connect("timeout", self, "_on_timeout")

func _on_timeout():
	set_process_unhandled_input(_type == "say")
	
func _unhandled_input(event):
	if Input.is_action_pressed("ren_forward"):
		ren.rolling_back = false
		if ren.history_id > 1:
			ren.history_id -= 1

		if typing: #if typing complete it
			typing=false
		else:      #else exit statement
			ren.emit_signal("exit_statement", {})

func _on_statement(type, kwargs):
	set_process(false)
	_type = type
	$Timer.start()
	if not _type in ["say", "input", "menu"]:
		return

	if "how" in kwargs:
		NameLabel.bbcode_text = kwargs.how
	
	if "what" in kwargs:
		if kwargs.has("speed"):
			writeDialog(kwargs.what, kwargs.speed)
		else:
			writeDialog(kwargs.what)
		

	if "avatar" in kwargs:
		if avatar_path != kwargs.avatar:
			if avatar != null:
				avatar.free()
				
		if kwargs.avatar != null:
			avatar_path = kwargs.avatar
			avatar = load(kwargs.avatar).instance()
			CharacterAvatar.add_child(avatar) 

	return
	
	
func writeDialog(text, speed=0.005):
    #create a timer to print text like a typewriter
	if t != null:
		t.free()
	
	if speed == 0:
		DialogText.bbcode_text=text
		return
	
	typing=true
	DialogText.bbcode_text = ""
	var te=""
	t = Timer.new()
	t.set_wait_time(speed)
	t.set_one_shot(true)
	self.add_child(t)
	
	for letter in text:
		t.start()
		te+=letter
		DialogText.bbcode_text=te
		yield(t, "timeout")
		if !typing:
			DialogText.bbcode_text=text
			break
