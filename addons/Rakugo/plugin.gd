tool
extends EditorPlugin


var rakugo_project_settings
var rps_container
var rakugo_tools
var tools_menu
var tm_container


func default_setting(setting: String, value):
	if not ProjectSettings.has_setting(setting):
		ProjectSettings.set_setting(setting, value)


func init_project_settings():
	default_setting(
		"application/rakugo/version",
		"0.0.1"
	)

	default_setting(
		"application/rakugo/game_credits",
		"Your Company"
	)

	default_setting(
		"application/rakugo/markup",
		"renpy"
	)

	default_setting(
		"application/rakugo/debug",
		false
	)

	default_setting(
		"application/rakugo/test_saves",
		false
	)

	default_setting(
		"application/rakugo/scenes_links",
		"res://game/scenes_links.tres"
	)

	default_setting(
		"application/rakugo/theme",
		"res://themes/Default/default.tres"
	)

	default_setting(
		"application/rakugo/punctuation_pause",
		"adv"
	)


func init_tools():
	var theme = get_editor_interface().get_base_control().theme

	rakugo_project_settings = preload("tools/project_settings/RakugoProjectSettings.tscn").instance()
	rakugo_project_settings.theme = theme
	rps_container = CONTAINER_PROJECT_SETTING_TAB_LEFT
	add_control_to_container(rps_container, rakugo_project_settings)
	rakugo_project_settings.connect_to_parten()

	rakugo_tools = preload("res://addons/Rakugo/tools/RakugoTools.tscn").instance()
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
	remove_control_from_container(rps_container, rakugo_project_settings)

	tools_menu.free()
	rakugo_tools.free()
	rakugo_project_settings.free()


func _exit_tree():
	remove_tools()
