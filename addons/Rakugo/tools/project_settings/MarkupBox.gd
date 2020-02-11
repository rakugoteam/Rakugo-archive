tool
extends HBoxContainer

var mode : String
var popup : PopupMenu
var modes := [
	"renpy",
	"bbcode"
]

func _ready() -> void:
	$TextureRect.texture = get_icon("TextFile", "EditorIcons")
	$Reload.icon = get_icon("Reload", "EditorIcons")
	$Reload.connect("pressed", self, "_on_reload")
	popup = $MenuButton.get_popup()
	var rich_text_icon = get_icon("RichTextLabel", "EditorIcons")
	popup.set_item_icon(1, rich_text_icon)
	popup.connect("id_pressed", self, "_on_text_mode")


func _on_reload() -> void:
	_on_text_mode(0)


func _on_text_mode(id:int) -> void:
	$MenuButton.text = popup.get_item_text(id)
	$MenuButton.icon = popup.get_item_icon(id)
	mode = modes[id]


func load_setting(use_cfg:bool, cfg:ConfigFile) -> void:
	mode = ProjectSettings.get_setting(
		"application/rakugo/markup")

	if use_cfg and cfg:
		mode = cfg.get_value("application", "rakugo/markup")

	_on_text_mode(modes.find(mode))


func save_setting(use_cfg:bool, cfg:ConfigFile) -> void:
	if use_cfg and cfg:
		cfg.set_value("application", "rakugo/markup", mode)
		return

	ProjectSettings.set_setting(
		"application/rakugo/markup", mode)
