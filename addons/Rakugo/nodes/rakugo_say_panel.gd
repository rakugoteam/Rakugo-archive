extends Panel
class_name RakugoSayPanel, "res://addons/Rakugo/icons/rakugo_panel.svg"

export (String, "adv", "hide", "top", "center", "left", "right", "nvl", "fullscreen") var kind = "adv"
export var main_container_path : = NodePath("")
export var std_kind_container_path : = NodePath("")
export (Array, String) var extra_kinds : = ["nvl", "phone_right", "phone_left"]
export (Array, PackedScene) var extra_kinds_scenes : = []
export (Array, String) var extra_kinds_anims : = ["nvl", "phone", "phone"]

var NameLabel : RichTextLabel
var DialogText : RichTextLabel
var CharacterAvatar : Viewport
var LineEditNode : RakugoAsk
var StdKindContainer : KindContainer
var MainContainer : BoxContainer
var CurrentKind : KindContainer
var ButtonNext : BaseButton

var avatar_path : = ""
var avatar : Node
var _type : int
var typing : = false
var _ui_accept := false

onready var allowed_statement_types = [
	Rakugo.StatementType.SAY,
	Rakugo.StatementType.ASK,
	Rakugo.StatementType.MENU
]

func _setup(kind_container:KindContainer):

	if ButtonNext:
		if ButtonNext.is_connected("pressed", self, "_press_accept"):
			ButtonNext.disconnect("pressed", self, "_press_accept")

		ButtonNext.hide()

	NameLabel = kind_container.NameLabel
	DialogText = kind_container.DialogText
	CharacterAvatar = kind_container.CharacterAvatar

	if LineEditNode:
		LineEditNode.active = false

		if ButtonNext.is_connected("pressed", LineEditNode, "enter"):
			ButtonNext.disconnect("pressed", LineEditNode, "enter")

	LineEditNode = kind_container.LineEditNode
	LineEditNode.active = true
	ButtonNext = kind_container.NextButton
	ButtonNext.connect("pressed", self, "_press_accept")
	ButtonNext.connect("pressed", LineEditNode, "enter")
	Rakugo.connect("hide_ui", self, "_on_hide")
	Rakugo.dialog_timer.connect("timeout", ButtonNext, "set_disabled", [true])
	CurrentKind = kind_container

func _on_hide(value:bool) -> void:
	visible = value

func _press_accept() -> void:
	_ui_accept = true

func _ready() -> void:
	MainContainer = get_node(main_container_path)
	StdKindContainer = get_node(std_kind_container_path)
	_setup(StdKindContainer)
	Rakugo.connect("exec_statement", self, "_on_statement")

func _unhandled_input(event: InputEvent) -> void:
	var ui_accept = event.is_action_pressed("ui_accept")
	_on_ui_accept(ui_accept)

func _on_ui_accept (value:bool) -> void:
	var ui_accept = value or _ui_accept

	if not ui_accept:
		return

	_ui_accept = false

	if not visible:
		Rakugo.emit_signal("hide_ui")
		return

	if not Rakugo.active:
		return

	Rakugo.debug(["ui_accept:", ui_accept])
	Rakugo.debug(["story_state", Rakugo.story_state])

	if Rakugo.skip_auto:
		Rakugo.auto_timer.stop_loop()
		Rakugo.skip_timer.stop_loop()
		Rakugo.skip_auto = false
		return

	if typing: # if typing complete it
		typing = false
		return

	elif _type == Rakugo.StatementType.SAY: # else exit statement
		Rakugo.exit_statement()

func _on_statement(type : int, parameters : Dictionary) -> void:
	kind = Rakugo.default_kind
	_type = type

	if not( _type in allowed_statement_types):
		return

	if _type != Rakugo.StatementType.MENU:
		ButtonNext.disabled = false

	if "kind" in parameters:
		kind = parameters.kind

		if not extra_kinds.has(kind):
			StdKindContainer.show()
			$Kinds.play(kind)

		if kind in extra_kinds:
			var i := extra_kinds.find(kind)

			$Kinds.play(extra_kinds_anims[i])

			StdKindContainer.hide()
			var scene_to_use : PackedScene = extra_kinds_scenes[i]
			var instace : KindContainer = scene_to_use.instance()
			MainContainer.add_child(instace)
			_setup(instace)
			$ScrollContainer.scroll_vertical += instace.rect_size.y*2

	if "who" in parameters:
		if NameLabel.has_method("set_bbcode"):
			NameLabel.bbcode_text = parameters.who

	if "what" in parameters:
		var _typing = Rakugo.get_value("typing_text")

		if typing in parameters:
			_typing = parameters.typing

		write_dialog(parameters.what, _typing)

	if "avatar" in parameters:
		if parameters.avatar != "":
			if StdKindContainer.visible:
				if avatar != null:
					avatar.free()

			CurrentKind.show_avatar()
			avatar_path = parameters.avatar
			avatar = load(avatar_path).instance()
			CharacterAvatar.add_child(avatar)

			var a = avatar as RakugoAvatar

			if a:
				a.state = parameters.avatar_state

		else:
			CurrentKind.hide_avatar()

	elif avatar != null:
		var wr = weakref(avatar)

		if not wr.get_ref():
			# object is erased
			avatar = null

		else:
			# object is fine so you can do something with it:
			avatar.free()

		CurrentKind.hide_avatar()

	if Rakugo.skipping:
		typing = false
		return

	if "time" in parameters:
		if parameters.time == 0:
			typing = false

		else:
			typing = true
			Rakugo.dialog_timer.wait_time = parameters.time

	else:
		typing = true
		Rakugo.dialog_timer.reset()

	return

func write_dialog(text : String, _typing : bool) -> void:
	typing = _typing

	if Rakugo.skipping:
		typing = false

	if not typing:
		if DialogText.has_method("set_bbcode"):
			DialogText.bbcode_text = text
		return

	if DialogText.has_method("set_bbcode"):
		DialogText.bbcode_text = ""

	var new_text : = ""
	var markup : = false

	for letter in text:
		new_text += letter

		if letter == "[":
			markup = true
			continue

		if new_text.ends_with("[img]"):
			markup = true
			continue

		if letter == "]":
			markup = false

		if new_text.ends_with("[/img]"):
			markup = false

		if markup:
			continue

		Rakugo.dialog_timer.start()

		yield(Rakugo.dialog_timer, "timeout")

		if DialogText.has_method("set_bbcode"):
			DialogText.bbcode_text = new_text

		if !typing:

			if DialogText.has_method("set_bbcode"):
				DialogText.bbcode_text = text

			break

func _on_Hide_toggled(button_pressed : bool) -> void:
	visible = !button_pressed
