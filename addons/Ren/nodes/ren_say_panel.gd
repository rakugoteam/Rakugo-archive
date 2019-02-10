extends Panel
class_name RenSayPanel, "res://addons/Ren/icons/ren_panel.svg"

export var name_label_path :  = NodePath("")
export var dialog_label_path : = NodePath("")
export var avatar_viewport_path : = NodePath("")

onready var NameLabel : RichTextLabel = get_node(name_label_path)
onready var DialogText : RichTextLabel = get_node(dialog_label_path)
onready var CharacterAvatar : Viewport = get_node(avatar_viewport_path)

var avatar_path : = ""
var avatar : Node
var _type : int
var typing : = false

func _ready() -> void:	
	Ren.connect("exec_statement", self, "_on_statement")

func _input(event : InputEvent) -> void:
	if not event.is_action_pressed("ui_accept"):
		return

	if not visible:
		visible = true
		return

	if not Ren.active:
		return
	
	if Ren.skip_auto:
		Ren.auto_timer.stop_loop()
		Ren.skip_timer.stop_loop()
		Ren.skip_auto = false
		return
	
	if typing: # if typing complete it
		typing = false
		return

	elif _type == Ren.StatementType.SAY: # else exit statement
		Ren.exit_statement()

func _on_statement(type : int, parameters : Dictionary) -> void:
	if "kind" in parameters:
		$AnimationPlayer.play(parameters.kind)
	
	_type = type

	if "who" in parameters:
		if NameLabel.has_method("set_bbcode"):
			NameLabel.bbcode_text = parameters.who

	if "what" in parameters:
		write_dialog(parameters.what, parameters.speed)

	if "avatar" in parameters:
		if avatar != null:
			avatar.free()

		if parameters.avatar != "":
			avatar_path = parameters.avatar
			avatar = load(parameters.avatar).instance()
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

func write_dialog(text : String, speed : float) -> void:
	if speed == 0:
		if DialogText.has_method("set_bbcode"):
			DialogText.bbcode_text = text
		return

	typing = true
	if DialogText.has_method("set_bbcode"):
		DialogText.bbcode_text = ""

	var te = ""
	var new_time = speed/100 * Ren.auto_timer.wait_time
	if new_time <= 0:
		new_time = 0.1
	Ren.dialog_timer.wait_time = new_time 

	var markup = false
	for letter in text:
		Ren.dialog_timer.start()
		te += letter
		if letter == "[":
			markup = true
		
		if letter == "]":
			markup = false

		if markup:
			continue

		if DialogText.has_method("set_bbcode"):
			DialogText.bbcode_text = te

		yield(Ren.dialog_timer, "timeout")
		if !typing:

			if DialogText.has_method("set_bbcode"):
				DialogText.bbcode_text = text

			break

func _on_Hide_toggled(button_pressed : bool) -> void:
	visible = !button_pressed
