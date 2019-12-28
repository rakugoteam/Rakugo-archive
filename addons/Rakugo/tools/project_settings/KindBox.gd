tool
extends HBoxContainer

var kind : String
var popup : PopupMenu

func _ready() -> void:
	$TextureRect.texture = get_icon("CanvasLayer", "EditorIcons")
	$Reload.icon = get_icon("Reload", "EditorIcons")
	$Reload.connect("pressed", self, "_on_reload")
	
	var icons = [
		get_icon("ControlAlignBottomWide", "EditorIcons"), # bottom / adv
		get_icon("ControlHcenterWide", "EditorIcons"), # center
		get_icon("ControlAlignWide", "EditorIcons"), # fullscreen
		get_icon("ControlAlignRightWide", "EditorIcons"), # right
		get_icon("ControlAlignLeftWide", "EditorIcons"), # left
		get_icon("ControlAlignTopWide", "EditorIcons"), # top
		get_icon("ControlAlignRightCenter", "EditorIcons"), # phone_right
		get_icon("ControlAlignLeftCenter", "EditorIcons"), # phone_left
		get_icon("Panels2", "EditorIcons"), # nvl
		get_icon("GuiVisibilityHidden", "EditorIcons") # hide
	]

	popup = $MenuButton.get_popup()
#	var items_size = popup.items.size()

	for id in range(icons.size()):
		popup.set_item_icon(id, icons[id])


func _on_reload() -> void:
	_on_kind(0)


func _on_kind(id:int) -> void:
	$MenuButton.text = popup.get_item_text(id)
	$MenuButton.icon = popup.get_item_icon(id)

	match id:
		0:
			kind = "adv"

		1:
			kind = "center"

		2:
			kind = "fullscreen"

		3:
			kind = "right"

		4:
			kind = "left"

		5:
			kind = "top"

		6:
			kind = "phone_left"

		7:
			kind = "phone_right"

		8:
			kind = "nvl"

		9:
			kind = "hide"


func load_setting() -> void:
	kind = ProjectSettings.get_setting(
		"application/rakugo/default_kind")

	match kind:
		"adv":
			_on_kind(0)

		"center":
			_on_kind(1)

		"fullscreen":
			_on_kind(2)

		"right":
			_on_kind(3)

		"left":
			_on_kind(4)

		"top":
			_on_kind(5)

		"phone_left":
			_on_kind(6)

		"phone_right":
			_on_kind(7)

		"nvl":
			_on_kind(8)

		"hide":
			_on_kind(9)


func save_setting() -> void:
	 ProjectSettings.set_setting(
		"application/rakugo/default_kind", kind)
