tool
extends MenuButton

var plugin:EditorPlugin

func _ready() -> void:
	var docs_icon := get_icon("Help", "EditorIcons")
	get_popup().set_item_icon(2, docs_icon)


func connect_to_plugin() -> void:
	# "res://addons/Rakugo/tools/RakugoTools.gd"
	get_popup().connect("id_pressed", plugin.rakugo_tools, "_on_menu")
