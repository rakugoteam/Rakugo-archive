extends Panel
class_name RakugoSayPanel, "res://addons/Rakugo/icons/rakugo_panel.svg"

export var main_container_path : = NodePath("")
export var std_kind_container_path : = NodePath("")
export (Array, String) var extra_kinds : = ["nvl", "phone_right", "phone_left"] 
export (Array, PackedScene) var extra_kinds_scenes : = []
export (Array, String) var extra_kinds_anims : = ["nvl", "phone", "phone"]

var NameLabel : RichTextLabel
var DialogText : RichTextLabel
var CharacterAvatar : Viewport
var LineEditNode : RakugoLineEdit
var StdKindContainer : KindContainer
var MainContainer : BoxContainer

var avatar_path : = ""
var avatar : Node
var _type : int
var typing : = false

func _setup(kind_container:KindContainer):	
	var nl_path : = kind_container.name_label_path
	NameLabel = kind_container.get_node(nl_path)
	
	var dl_path := kind_container.dialog_label_path
	DialogText = kind_container.get_node(dl_path)
	
	var av_path : = kind_container.avatar_viewport_path
	CharacterAvatar = kind_container.get_node(av_path)
	
	if LineEditNode:
		LineEditNode.active = false
	
	var le_path := kind_container.line_edit_path
	LineEditNode = kind_container.get_node(le_path)
	LineEditNode.active = true
	
func _ready() -> void:
	MainContainer = get_node(main_container_path)
	StdKindContainer = get_node(std_kind_container_path)
	_setup(StdKindContainer)
	Rakugo.connect("exec_statement", self, "_on_statement")

func _input(event : InputEvent) -> void:
	if not event.is_action_pressed("ui_accept"):
		return

	if not visible:
		visible = true
		return

	if not Rakugo.active:
		return
	
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
	var kind : String 
	if "kind" in parameters:
		kind = parameters.kind
	
	if not extra_kinds.has(kind):
		$AnimationPlayer.play(kind)
		
	if kind in extra_kinds:
		var i := extra_kinds.find(kind)
		
		if i == -1:
			return
		
		$AnimationPlayer.play(extra_kinds_anims[i])
		
		StdKindContainer.hide()
		var scene_to_use : PackedScene = extra_kinds_scenes[i]
		var instace : KindContainer = scene_to_use.instance()
		MainContainer.add_child(instace)
		_setup(instace)
	
	else:
		StdKindContainer.show()
		
	_type = type

	if "who" in parameters:
		if NameLabel.has_method("set_bbcode"):
			NameLabel.bbcode_text = parameters.who

	if "what" in parameters:
		var _typing = Rakugo.get_value("typing_text")
		
		if typing in parameters:
			_typing = parameters.typing
		
		write_dialog(parameters.what, _typing)

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

func write_dialog(text : String, _typing : bool) -> void:
	typing = _typing
	if not typing:
		if DialogText.has_method("set_bbcode"):
			DialogText.bbcode_text = text
		return

	if DialogText.has_method("set_bbcode"):
		DialogText.bbcode_text = ""

	var te = ""

	var markup = false
	for letter in text:
		Rakugo.dialog_timer.start()
		te += letter
		if letter == "[":
			markup = true
		
		if letter == "]":
			markup = false

		if markup:
			continue

		if DialogText.has_method("set_bbcode"):
			DialogText.bbcode_text = te

		yield(Rakugo.dialog_timer, "timeout")
		if !typing:

			if DialogText.has_method("set_bbcode"):
				DialogText.bbcode_text = text

			break

func _on_Hide_toggled(button_pressed : bool) -> void:
	visible = !button_pressed
	
