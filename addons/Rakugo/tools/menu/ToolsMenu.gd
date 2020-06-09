tool
extends MenuButton

var plugin:EditorPlugin

func _ready() -> void:
	var docs_icon := get_icon("Help", "EditorIcons")
	get_popup().set_item_icon(2, docs_icon)


func connect_to_plugin() -> void:
	get_popup().connect("id_pressed", plugin.rakugo_tools, "_on_menu")


func _on_id(id:int) -> void:
	match id:
		# Emoji Panel
		0:
			plugin.emoji_panel.popup_centered()

		# ScenesLinks Tool
		1:
			plugin.sl_tool.popup_centered()

		# Rakugo Docs
		2:
			plugin.open_rakugo_docs()

		# About Rakugo
		3:
			plugin.open_about_dialog()

		# Rakugo Website:
		4:
			plugin.open_website() 
