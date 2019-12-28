tool
extends EditorPlugin

var emoji_panel
var sl_tool
var rakugo_project_settings
var tools_menu

func default_setting(setting: String, value):
	if not ProjectSettings.has_setting(setting):
		ProjectSettings.set_initial_value(setting, value)


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
		"application/rakugo/save_folder",
		"saves"
	)

	default_setting(
		"application/rakugo/theme",
		"res://themes/question/question.tres"
	)

	default_setting(
		"application/rakugo/default_kind",
		"adv"
	)


func init_tools():
	var theme = get_editor_interface().get_base_control().theme
	
	# Load the emoji_panel scene and instance it
	emoji_panel = preload("emojis/EmojiPanel.tscn").instance()
	emoji_panel.theme = theme
	add_child(emoji_panel)

	sl_tool = preload("tools/scenes_links/ScenesLinksModify.tscn").instance()
	sl_tool.theme = theme
	sl_tool.get_node("ScenesLinks").plugin_ready(get_editor_interface())
	add_child(sl_tool)

	rakugo_project_settings = preload("tools/project_settings/RakugoProjectSettings.tscn").instance()
	rakugo_project_settings.theme = theme
	add_child(rakugo_project_settings)

	tools_menu = preload("tools/menu/ToolsMenu.tscn").instance()
	tools_menu.plugin = self
	add_control_to_container(
		EditorPlugin.CONTAINER_TOOLBAR, tools_menu)


func add_custom_types():
	add_custom_type(
		"VRakugoMenu",
		"VBoxContainer",
		preload("nodes/rakugo_menu.gd"),
		preload("icons/rakugo_menu_v.svg")
	)

	add_custom_type(
		"HRakugoMenu",
		"HBoxContainer",
		preload("nodes/rakugo_menu.gd"),
		preload("icons/rakugo_menu_h.svg")
	)

	add_custom_type(
		"RakugoVarCheckButton",
		"CheckButton",
		preload("nodes/rakugo_var_check.gd"),
		preload("icons/rakugo_check_box.svg")
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
	emoji_panel.free()
	sl_tool.free()
	rakugo_project_settings.free()

	remove_control_from_container(
		EditorPlugin.CONTAINER_TOOLBAR, tools_menu)
	tools_menu.free()

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
