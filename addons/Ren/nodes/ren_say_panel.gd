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
var dialog_timer
var typing=false


func _ready():
	connect("gui_input", self, "_on_Adv_gui_input", [], CONNECT_PERSIST)
	Ren.connect("exec_statement", self, "_on_statement", [], CONNECT_PERSIST)
	$Timer.connect("timeout", self, "_on_timeout", [], CONNECT_PERSIST)

func _on_timeout():
	set_process_input(_type == "say")
	set_process_unhandled_key_input(_type == "say")

func _input(event):
	if Ren.skip_auto:
		return

	if event.is_action_pressed("ren_forward"):
		Ren.rolling_back = false
		if Ren.history_id > 1:
			Ren.history_id -= 1

		if typing: #if typing complete it
			typing=false
		elif _type == "say":      #else exit statement
			Ren.exit_statement()

func _on_statement(type, kwargs):
	if "kind" in kwargs:
		$AnimationPlayer.play(kwargs.kind)
	
	_type = type
	$Timer.start()
	if not _type in ["say", "input", "menu"]:
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
		avatar.free()

	return

func writeDialog(text, speed=0.005):
	if speed == 0:
		if DialogText.has_method("set_bbcode"):
			DialogText.bbcode_text=text
		return

	typing=true
	if DialogText.has_method("set_bbcode"):
		DialogText.bbcode_text = ""
	var te=""
	$DialogTimer.wait_time = speed

	for letter in text:
		$DialogTimer.start()
		te+=letter

		if DialogText.has_method("set_bbcode"):
			DialogText.bbcode_text=te

		yield($DialogTimer, "timeout")
		if !typing:

			if DialogText.has_method("set_bbcode"):
				DialogText.bbcode_text=text

			break


func _on_Adv_gui_input(ev):
	if ev is InputEventMouseButton:
		if ev.button_index == BUTTON_LEFT:
			var event=InputEventAction.new()
			event.action="ren_forward"
			event.pressed=true
			Input.parse_input_event(event)
