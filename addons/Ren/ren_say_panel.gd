extends Panel

export(float) var step_time = 0.05
export(NodePath) var name_label_path = NodePath("")
export(NodePath) var dialog_label_path = NodePath("")
export(NodePath) var avatar_viewport_path = NodePath("")

onready var NameLabel = get_node(name_label_path)
onready var DialogText = get_node(dialog_label_path)
onready var CharacterAvatar = get_node(avatar_viewport_path)


onready var timer = new_timer(step_time)

var avatar_path = ""
var avatar
var _type
var dialog_timer
var typing=false


func _ready():
	connect("gui_input", self, "_on_Adv_gui_input")
	Ren.connect("enter_statement", self, "_on_statement")
	timer.connect("timeout", self, "_on_timeout")

func _on_timeout():
	set_process_unhandled_input(_type == "say")

func _input(event):
	if event.is_action_pressed("ren_forward"):
		Ren.rolling_back = false
		if Ren.history_id > 1:
			Ren.history_id -= 1

		if typing: #if typing complete it
			typing=false
		else:      #else exit statement
			Ren.emit_signal("exit_statement", {})

func _on_statement(id, type, kwargs):
	set_process(false)
	_type = type
	timer.start()
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
		if avatar_path != kwargs.avatar:
			if avatar != null:
				avatar.free()

		if kwargs.avatar != null:
			avatar_path = kwargs.avatar
			avatar = load(kwargs.avatar).instance()
			CharacterAvatar.add_child(avatar)

	return

func new_timer(time):
	var nt = Timer.new()
	nt.set_wait_time(time)
	nt.set_one_shot(true)
	return nt

func writeDialog(text, speed=0.005):
    #create a timer to print text like a typewriter
	if dialog_timer != null:
		dialog_timer.free()

	if speed == 0:
		if DialogText.has_method("set_bbcode"):
			DialogText.bbcode_text=text
		return

	typing=true
	if DialogText.has_method("set_bbcode"):
		DialogText.bbcode_text = ""
	var te=""
	dialog_timer = new_timer(speed)
	self.add_child(dialog_timer)

	for letter in text:
		dialog_timer.start()
		te+=letter

		if DialogText.has_method("set_bbcode"):
			DialogText.bbcode_text=te

		yield(dialog_timer, "timeout")
		if !typing:

			if DialogText.has_method("set_bbcode"):
				DialogText.bbcode_text=text

			break


func _on_Adv_gui_input(ev):
	if ev is InputEventMouseButton:
		var event=InputEventAction.new()
		event.action="ren_forward"
		event.pressed=true
		Input.parse_input_event(event)
