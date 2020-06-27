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
		"res://themes/question/question.tres"
	)

	default_setting(
		"application/rakugo/default_kind",
		"adv"
	)

	default_setting(
		"application/rakugo/punctuation_pause",
		"adv"
	)

	default_setting(
		"application/rakugo/default_mkind",
		"vertical"
	)

	default_setting(
		"application/rakugo/default_mcolumns",
		2
	)

	default_setting(
		"application/rakugo/default_manchor",
		"center"
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


func add_custom_types():
	add_custom_type(
		"RakugoVarCheckButton",
		"CheckButton",
		preload("nodes/rakugo_var_check.gd"),
		preload("icons/rakugo_check_button.svg")
	)

	add_custom_type(
		"RakugoVarCheckBox",
		"CheckBox",
		preload("nodes/rakugo_var_check.gd"),
		preload("icons/rakugo_check_box.svg")
	)

	add_custom_type(
		"RakugoVarHSlider",
		"HSlider",
		preload("nodes/rakugo_var_slider.gd"),
		preload("icons/rakugo_var_h_slider.svg")
	)

	add_custom_type(
		"RakugoVarVSlider",
		"VSlider",
		preload("nodes/rakugo_var_slider.gd"),
		preload("icons/rakugo_var_v_slider.svg")
	)

	add_custom_type(
		"RakugoProgressBar",
		"ProgressBar",
		preload("nodes/rakugo_var_range.gd"),
		preload("icons/rakugo_progress_bar.svg")
	)

	add_custom_type(
		"RakugoTextureProgress",
		"TextureProgress",
		preload("nodes/rakugo_var_range.gd"),
		preload("icons/rakugo_texture_progress.svg")
	)


func _enter_tree():
	# Initialization of the plugin goes here

	# ProjectSettings for first time
	init_project_settings()

	add_custom_types()

	init_tools()

	print("Rakugo is enabled")


func remove_tools():
	remove_control_from_container(tm_container, tools_menu)
	remove_control_from_container(rps_container, rakugo_project_settings)

	tools_menu.free()
	rakugo_tools.free()
	rakugo_project_settings.free()


func remove_custom_types():
	remove_custom_type("RakugoVarHSlider")
	remove_custom_type("RakugoVarVSlider")
	remove_custom_type("RakugoHMenu")
	remove_custom_type("RakugoVMenu")
	remove_custom_type("RakugoVarCheckBox")
	remove_custom_type("RakugoVarCheckButton")
	remove_custom_type("RakugoProgressBar")
	remove_custom_type("RakugoTextureProgress")


func _exit_tree():
	remove_tools()
	remove_custom_types()
