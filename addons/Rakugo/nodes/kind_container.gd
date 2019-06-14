extends Control
class_name KindContainer

export var name_label_path : = NodePath("")
export var dialog_label_path : = NodePath("")
export var avatar_viewport_path : = NodePath("")
export var avatar_container_path := NodePath("")
export var line_edit_path : = NodePath("")
export var next_button_path := NodePath("")

onready var NameLabel : RichTextLabel = get_node(name_label_path)
onready var	DialogText : RichTextLabel = get_node(dialog_label_path)
onready var CharacterAvatar : Viewport = get_node(avatar_viewport_path)
onready var LineEditNode : RakugoAsk = get_node(line_edit_path)
onready var AvatarContainer : Container = get_node(avatar_container_path)
onready var NextButton : BaseButton = get_node(next_button_path)

func hide_avatar():
	AvatarContainer.hide()

func show_avatar():
	AvatarContainer.show()