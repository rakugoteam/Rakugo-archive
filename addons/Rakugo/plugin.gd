tool
extends EditorPlugin

var emoji_panel
var sl_tool
var rakugo_project_settings
var rps_container
var tools_menu
var tm_container
var about_dialog

# To test how godot plugin add_control_to_container() funcs works
var test_button
var test_container

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
	rps_container = CONTAINER_PROJECT_SETTING_TAB_LEFT
	add_control_to_container(rps_container, rakugo_project_settings)
	rakugo_project_settings.connect_to_parten()

	tools_menu = preload("tools/menu/ToolsMenu.tscn").instance()
	tools_menu.theme = theme
	tools_menu.plugin = self
	tm_container = CONTAINER_TOOLBAR
	add_control_to_container(tm_container, tools_menu)
	var p = tools_menu.get_parent()
	p.move_child(tools_menu, 0)

	# test_button = Button.new()
	# test_button.theme = theme
	# test_button.text = "test";
	# test_container = CONTAINER_TOOLBAR
	# add_control_to_container(test_container, test_button)
	# var p = test_button.get_parent()
	# p.move_child(test_button, 0)

	about_dialog = preload("tools/about/AboutDialog.tscn").instance()
	about_dialog.theme = theme
	add_child(about_dialog)


func open_emojis() -> void:
	emoji_panel.popup_centered()


func open_sl_tool() -> void:
	sl_tool.popup_centered()


func open_rakugo_docs() -> void:
	OS.shell_open("https://rakugo.readthedocs.io/en/latest/")


func open_website():
	OS.shell_open("https://rakugoteam.github.io/")


func open_about_dialog():
	about_dialog.popup_centered()


func add_custom_types():
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
	remove_control_from_container(tm_container, tools_menu)
	remove_control_from_container(rps_container, rakugo_project_settings)
	# remove_control_from_container(test_container, test_button)

	tools_menu.free()
	emoji_panel.free()
	sl_tool.free()
	rakugo_project_settings.free()
	# test_button.free()
	about_dialog.free()


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
