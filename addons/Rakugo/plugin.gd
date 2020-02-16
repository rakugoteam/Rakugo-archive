tool
extends EditorPlugin

var emoji_panel
var sl_tool
var rakugo_project_settings
var tools_menu
var about_dialog

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
	add_tool_menu_item("Browse Rakugo Emojis", self, "open_emojis")

	sl_tool = preload("tools/scenes_links/ScenesLinksModify.tscn").instance()
	sl_tool.theme = theme
	sl_tool.get_node("ScenesLinks").plugin_ready(get_editor_interface())
	add_child(sl_tool)
	add_tool_menu_item("Edit Rakugo ScenesLinks", self, "open_sl_tool")

	rakugo_project_settings = preload("tools/project_settings/RakugoProjectSettings.tscn").instance()
	rakugo_project_settings.theme = theme
	add_child(rakugo_project_settings)
	add_tool_menu_item("Edit Rakugo Project Settings", self, "open_rakugo_project_settings")

	add_tool_menu_item("Open RakugoDocs", self, "open_rakugo_docs")

	about_dialog = preload("tools/about/AboutDialog.tscn").instance()
	about_dialog.theme = theme
	add_child(about_dialog)
	add_tool_menu_item("About Rakugo", self, "open_about_dialog")


func open_emojis(arg) -> void:
	emoji_panel.popup_centered()


func open_sl_tool(arg) -> void:
	sl_tool.popup_centered()


func open_rakugo_project_settings(arg) -> void:
	rakugo_project_settings.load_settings()
	rakugo_project_settings.popup_centered()


func open_rakugo_docs(arg) -> void:
	OS.shell_open("https://rakugo.readthedocs.io/en/latest/")


func open_about_dialog(arg):
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
	emoji_panel.free()
	sl_tool.free()
	rakugo_project_settings.free()
	about_dialog.free()

	remove_tool_menu_item("Browse Rakugo Emojis")
	remove_tool_menu_item("Edit Rakugo ScenesLinks")
	remove_tool_menu_item("Edit Rakugo Project Settings")
	remove_tool_menu_item("Open RakugoDocs")
	remove_tool_menu_item("About Rakugo")


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
