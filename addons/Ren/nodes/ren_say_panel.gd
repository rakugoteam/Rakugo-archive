extends Panel

export(NodePath) var name_label_path = NodePath("")
export(NodePath) var dialog_label_path = NodePath("")
export(NodePath) var avatar_viewport_path = NodePath("")
export(float) var step_time = 0.01
export(float) var letter_speed = 0.005

onready var NameLabel = get_node(name_label_path)
onready var DialogText = get_node(dialog_label_path)
onready var CharacterAvatar = get_node(avatar_viewport_path)
onready var ActionTimer = Timer.new()
onready var DialogTimer = Timer.new()

var avatar_path = ""
var avatar
var _type
var typing = false
var active = true


func _ready():
	connect("gui_input", self, "_on_Adv_gui_input")
	Ren.connect("exec_statement", self, "_on_statement")
	ActionTimer.one_shot = true
	ActionTimer.wait_time = step_time
	ActionTimer.connect("timeout", self, "_on_time_active_timeout")
	add_child(ActionTimer)
	DialogTimer.one_shot = true
	add_child(DialogTimer)

func _on_time_active_timeout():
	active = true

func _input(event):
	if not event.is_action_pressed("ren_forward"):
		return
	
	if ActionTimer.is_stopped():
		active = false
		ActionTimer.start()

	if Ren.skip_auto:
		Ren.skip_auto = true
		return

	elif typing: # if typing complete it
		typing = false
		return

	elif _type == "say": # else exit statement
		active = true
		ActionTimer.stop()
		Ren.exit_statement()


func _on_statement(type, kwargs):
	if "kind" in kwargs:
		$AnimationPlayer.play(kwargs.kind)
	
	_type = type

	if not _type in ["say", "ask", "menu"]:
		return

	if "who" in kwargs:
		if NameLabel.has_method("set_bbcode"):
			NameLabel.bbcode_text = kwargs.who

	if "what" in kwargs:
		if kwargs.has("speed"):
			writeDialog(kwargs.what, kwargs.speed)
		else:
			writeDialog(kwargs.what)

	if "avatar" in kwargs:
		if avatar != null:
			avatar.free()

		if kwargs.avatar != "":
			avatar_path = kwargs.avatar
			avatar = load(kwargs.avatar).instance()
			CharacterAvatar.add_child(avatar)
	
	elif avatar != null:
		var wr = weakref(avatar)
		
		if (!wr.get_ref()):
			 # object is erased
			avatar = null
		else:
			# object is fine so you can do something with it:
			avatar.free()
		
	return

func writeDialog(text, speed = letter_speed):
	if speed == 0:
		if DialogText.has_method("set_bbcode"):
			DialogText.bbcode_text = text
		return

	typing = true
	if DialogText.has_method("set_bbcode"):
		DialogText.bbcode_text = ""

	var te = ""
	DialogTimer.wait_time = speed

	for letter in text:
		DialogTimer.start()
		te += letter

		if DialogText.has_method("set_bbcode"):
			DialogText.bbcode_text = te

		yield(DialogTimer, "timeout")
		if !typing:

			if DialogText.has_method("set_bbcode"):
				DialogText.bbcode_text = text

			break


func _on_Adv_gui_input(ev):
	if not active:
		return

	if not (ev is InputEventMouseButton):
		return

	if ev.button_index == BUTTON_LEFT:
		var event = InputEventAction.new()
		event.action = "ren_forward"
		event.pressed = true
		Input.parse_input_event(event)
