tool
extends HBoxContainer

var rps : RakugoProjectSettings

var kind : String
var anchor : String
var kpopup : PopupMenu
var apopup : PopupMenu

var kinds :=  [
	"vertical",
	"horizontal",
	"grid"
	]

var anchors := [
	"top_left",
	"top_right",
	"bottom_left",
	"bottom_right",
	"center_left",
	"center_top",
	"center_right",
	"center_bottom",
	"center"
	]


func _ready() -> void:
	$Reload.icon = get_icon("Reload", "EditorIcons")
	$Reload.connect("pressed", self, "_on_reload")

	var kinds_icons := [
		get_icon("VBoxContainer", "EditorIcons"), # vertical
		get_icon("HBoxContainer", "EditorIcons"), # horizontal
		get_icon("GridContainer", "EditorIcons") # grid
	]

	kpopup = $MKindButton.get_popup()
	kpopup.clear()
	kpopup.connect("id_pressed", self, "_on_kind")

	for k in kinds:
		kpopup.add_item(k)

	for id in range(kinds_icons.size()):
		kpopup.set_item_icon(id, kinds_icons[id])

	var anchors_icons := [
		get_icon("ControlAlignTopLeft", "EditorIcons"), # top left
		get_icon("ControlAlignTopRight", "EditorIcons"), # top right
		get_icon("ControlAlignBottomLeft", "EditorIcons"), # bottom left
		get_icon("ControlAlignBottomRight", "EditorIcons"), # bottom right
		get_icon("ControlAlignLeftCenter", "EditorIcons"), # center left
		get_icon("ControlAlignTopCenter", "EditorIcons"), # center top
		get_icon("ControlAlignRightCenter", "EditorIcons"), # center right
		get_icon("ControlAlignBottomCenter", "EditorIcons"), # center bottom
		get_icon("ControlAlignCenter", "EditorIcons") # center
	]

	apopup = $MAnchorButton.get_popup()
	apopup.clear()
	apopup.connect("id_pressed", self, "_on_anchor")

	for a in anchors:
		apopup.add_item(a)

	for id in range(anchors_icons.size()):
		apopup.set_item_icon(id, anchors_icons[id])


func _on_reload() -> void:
	_on_kind(0)
	_on_anchor(anchors.size() - 1)


func _on_kind(id:int) -> void:
	$MKindButton.text = kpopup.get_item_text(id)
	$MKindButton.icon = kpopup.get_item_icon(id)
	kind = kinds[id]
	update_box()


func _on_anchor(id:int) -> void:
	$MAnchorButton.text = apopup.get_item_text(id)
	$MAnchorButton.icon = apopup.get_item_icon(id)
	anchor = anchors[id]


func load_setting() -> void:
	kind = rps.get_setting("rakugo/default_mkind")
	_on_kind(kinds.find(kind))

	$SpinBox.value = int(
		rps.get_setting("rakugo/default_mcolumns"))

	update_box()

	anchor = rps.get_setting("rakugo/default_manchor")
	_on_anchor(anchors.find(anchor))


func update_box() -> void:
	$SpinBox.visible = kind == "grid"


func save_setting() -> void:
	rps.set_setting("rakugo/default_mkind", kind)
	rps.set_setting("rakugo/default_mcolumns", $SpinBox.value)
	rps.set_setting("rakugo/default_manchor", anchor)
