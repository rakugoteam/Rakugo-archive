tool
extends HBoxContainer

var mode : String
var popup : PopupMenu

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
	
	match id:
		0:
			mode = "renpy"
		
		1:
			mode = "bbcode"


func load_setting() -> void:
	mode = ProjectSettings.get_setting(
		"application/rakugo/markup")
	
	match mode:
		"renpy":
			_on_text_mode(0)
		
		"bbcode":
			_on_text_mode(1)


func save_setting() -> void:
	 ProjectSettings.set_setting(
		"application/rakugo/markup", mode)
