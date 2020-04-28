tool
extends MenuButton

var plugin:EditorPlugin

func _ready() -> void:
	var cfg_icon := get_icon("HSlider", "EditorIcons")
	var docs_icon := get_icon("Help", "EditorIcons")
	var info_icon := get_icon("InformationSign", "EditorIcons")
	var web_icon := get_icon("WorldEnvironment", "EditorIcons")
	
	get_popup().set_item_icon(0, cfg_icon)
	get_popup().set_item_icon(3, docs_icon)
	get_popup().set_item_icon(4, info_icon)
	get_popup().set_item_icon(5, web_icon)
	
	get_popup().connect("id_pressed", self, "_on_id")


func _on_id(id:int) -> void:
	match id:
		# Rakugo Project Settings
		0:
			plugin.open_rps()
		
		# Emoji Panel
		1:
			plugin.emoji_panel.popup_centered()

		# ScenesLinks Tool
		2:
			plugin.sl_tool.popup_centered()

		# Rakugo Docs
		3:
			plugin.open_rakugo_docs()

		# About Rakugo
		4:
			plugin.open_about_dialog()
		
		# Rakugo Website:
		5:
			plugin.open_website() 
