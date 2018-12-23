extends Panel

export(NodePath) var name_label_path = NodePath("")
export(NodePath) var dialog_label_path = NodePath("")
export(NodePath) var avatar_viewport_path = NodePath("")

onready var NameLabel = get_node(name_label_path)
onready var DialogText = get_node(dialog_label_path)
onready var CharacterAvatar = get_node(avatar_viewport_path)

var avatar_path = ""
var avatar
var _type
var typing = false
var active = true


func _ready():
	connect("gui_input", self, "_on_adv_gui_input")
	Ren.connect("exec_statement", self, "_on_statement")
	$StepTimer.connect("timeout", self, "_on_time_active_timeout")


func _on_time_active_timeout():
	active = true

func _input(event):
	if not event.is_action_pressed("ren_forward"):
		return
	
	if $StepTimer.is_stopped():
		active = false
		$StepTimer.start()

	if Ren.skip_auto:
		Ren.auto_timer.stop_loop()
		Ren.skip_timer.stop_loop()
		
		Ren.skip_auto = false

	elif typing: # if typing complete it
		typing = false
		return

	elif _type == Ren.StatementType.SAY: # else exit statement
		active = true
		$StepTimer.stop()
		Ren.exit_statement()


func _on_statement(type, kwargs):
	if "kind" in kwargs:
		$AnimationPlayer.play(kwargs.kind)
	
	_type = type

	if "who" in kwargs:
		if NameLabel.has_method("set_bbcode"):
			NameLabel.bbcode_text = kwargs.who

	if "what" in kwargs:
		write_dialog(kwargs.what, kwargs.speed)

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

func write_dialog(text, speed):
	if speed == 0:
		if DialogText.has_method("set_bbcode"):
			DialogText.bbcode_text = text
		return

	typing = true
	if DialogText.has_method("set_bbcode"):
		DialogText.bbcode_text = ""

	var te = ""
	$DialogTimer.wait_time = speed

	var markup = false
	for letter in text:
		$DialogTimer.start()
		te += letter
		if letter == "[":
			markup = true
		
		if letter == "]":
			markup = false

		if markup:
			continue

		if DialogText.has_method("set_bbcode"):
			DialogText.bbcode_text = te

		yield($DialogTimer, "timeout")
		if !typing:

			if DialogText.has_method("set_bbcode"):
				DialogText.bbcode_text = text

			break


func _on_adv_gui_input(ev):
	if not active:
		return

	if not (ev is InputEventMouseButton):
		return

	if ev.button_index == BUTTON_LEFT:
		var event = InputEventAction.new()
		event.action = "ren_forward"
		event.pressed = true
		Input.parse_input_event(event)
