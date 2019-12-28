tool
extends MenuButton

var plugin:EditorPlugin

func _ready() -> void:
	var settings_icon := get_icon("GDScript", "EditorIcons")
	get_popup().set_item_icon(2, settings_icon)
	
	var docs_icon := get_icon("Help", "EditorIcons")
	get_popup().set_item_icon(3, docs_icon)
	
	get_popup().connect("id_pressed", self, "_on_id")


func _on_id(id:int) -> void:
	match id:
		# Emoji Panel
		0:
			plugin.emoji_panel.popup_centered()
		
		# ScenesLinks Tool
		1:
			plugin.sl_tool.popup_centered()
		
		# Rakugo Project Settings
		2:
			plugin.rakugo_project_settings.load_settings()
			plugin.rakugo_project_settings.popup_centered()
		
		# Rakugo Docs
		3:
			OS.shell_open("https://rakugo.readthedocs.io/en/latest/")


