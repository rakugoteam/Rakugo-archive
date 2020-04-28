tool
extends HBoxContainer

var rps : RakugoProjectSettings

var kind : String
var popup : PopupMenu
var kinds :=  [
	"adv",
	"center",
	"fullscreen",
	"right",
	"left",
	"top",
	"phone_left",
	"phone_right",
	"nvl"
	]

func _ready() -> void:
	$Reload.icon = get_icon("Reload", "EditorIcons")
	$Reload.connect("pressed", self, "_on_reload")

	var icons := [
		get_icon("ControlAlignBottomWide", "EditorIcons"), # bottom / adv
		get_icon("ControlHcenterWide", "EditorIcons"), # center
		get_icon("ControlAlignWide", "EditorIcons"), # fullscreen
		get_icon("ControlAlignRightWide", "EditorIcons"), # right
		get_icon("ControlAlignLeftWide", "EditorIcons"), # left
		get_icon("ControlAlignTopWide", "EditorIcons"), # top
		get_icon("ControlAlignRightCenter", "EditorIcons"), # phone_right
		get_icon("ControlAlignLeftCenter", "EditorIcons"), # phone_left
		get_icon("Panels2", "EditorIcons") # nvl
	]

	popup = $MenuButton.get_popup()
	popup.connect("id_pressed", self, "_on_kind")

	for id in range(icons.size()):
		popup.set_item_icon(id, icons[id])


func _on_reload() -> void:
	_on_kind(0)


func _on_kind(id:int) -> void:
	$MenuButton.text = popup.get_item_text(id)
	$MenuButton.icon = popup.get_item_icon(id)
	kind = kinds[id]


func load_setting() -> void:
	kind = rps.get_setting("rakugo/default_kind")
	_on_kind(kinds.find(kind))


func save_setting() -> void:
	 rps.set_setting("rakugo/default_kind", kind)
