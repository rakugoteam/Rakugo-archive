tool
extends EditorPlugin

var rakugo_tools
var tools_menu
var tm_container

func init_project_settings():
	ProjectTools.set_setting(
		"rakugo/game/version",
		"0.0.1", PropertyInfo.new(
			"", TYPE_STRING, PROPERTY_HINT_NONE, 
			"", PROPERTY_USAGE_DEFAULT)
	)

	ProjectTools.set_setting(
		"rakugo/game/game_credits",
		"Your Company", PropertyInfo.new(
			"", TYPE_STRING, PROPERTY_HINT_MULTILINE_TEXT, 
			"", PROPERTY_USAGE_DEFAULT)
	)

	ProjectTools.set_setting(
		"rakugo/game/scenes_links",
		"res://game/scenes_links.tres", PropertyInfo.new(
			"", TYPE_STRING, PROPERTY_HINT_FILE, 
			"*.tres", PROPERTY_USAGE_DEFAULT)
	)

	ProjectTools.set_setting(
		"rakugo/gui/markup",
		"renpy", PropertyInfo.new(
			"", TYPE_STRING, PROPERTY_HINT_ENUM, 
			"renpy,bbcode", PROPERTY_USAGE_CATEGORY)
	)

	ProjectTools.set_setting(
		"rakugo/gui/theme",
		"res://themes/Default/default.tres",
		PropertyInfo.new(
			"", TYPE_STRING, PROPERTY_HINT_FILE, 
			"*.tres", PROPERTY_USAGE_DEFAULT)
	)

	ProjectTools.set_setting(
		"rakugo/gui/save_screen_layout",
		"save_pages", PropertyInfo.new(
			"", TYPE_STRING, PROPERTY_HINT_ENUM, 
			"save_pages,save_list", PROPERTY_USAGE_DEFAULT)
	)

	ProjectTools.set_setting(
		"rakugo/default/punctuation_pause",
		"0", PropertyInfo.new(
			"", TYPE_INT, PROPERTY_HINT_RANGE, 
			"0,10", PROPERTY_USAGE_DEFAULT)
	)

	ProjectTools.set_setting(
		"rakugo/default/narrator_label",
		"", PropertyInfo.new(
			"", TYPE_STRING, PROPERTY_HINT_NONE, 
			"", PROPERTY_USAGE_DEFAULT)
	)

	ProjectTools.set_setting(
		"rakugo/default/narrator_color",
		Color.white, PropertyInfo.new(
			"", TYPE_COLOR, PROPERTY_HINT_NONE, 
			"", PROPERTY_USAGE_DEFAULT)
	)



	ProjectTools.set_setting(
		"rakugo/editor/debug",
		false, PropertyInfo.new(
			"", TYPE_BOOL, PROPERTY_HINT_NONE, 
			"", PROPERTY_USAGE_EDITOR)
	)

	ProjectTools.set_setting(
		"rakugo/editor/test_saves",
		false, PropertyInfo.new(
			"", TYPE_BOOL, PROPERTY_HINT_NONE, 
			"", PROPERTY_USAGE_EDITOR)
	)


func init_tools():
	var theme = get_editor_interface().get_base_control().theme

	rakugo_tools = preload("res://addons/rakugo/tools/RakugoTools.tscn").instance()
	rakugo_tools.theme = theme
	add_child(rakugo_tools)

	tools_menu = preload("tools/menu/ToolsMenu.tscn").instance()
	tools_menu.theme = theme
	tools_menu.plugin = self
	tools_menu.connect_to_plugin()
	tm_container = CONTAINER_TOOLBAR
	add_control_to_container(tm_container, tools_menu)
	var p = tools_menu.get_parent()
	p.move_child(tools_menu, 0)


func _enter_tree():
	# Initialization of the plugin goes here
	
	init_project_settings()
	init_tools()

	print("Rakugo is enabled")


func remove_tools():
	remove_control_from_container(tm_container, tools_menu)

	tools_menu.free()
	rakugo_tools.free()


func _exit_tree():
	remove_tools()
