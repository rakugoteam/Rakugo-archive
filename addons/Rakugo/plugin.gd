tool
extends EditorPlugin

# A class member to hold the dock during the plugin lifecycle
var dock

func default_setting(setting:String, value):
	if not ProjectSettings.has_setting(setting):
		ProjectSettings.set_setting(setting, value)

func _enter_tree():
	# Initialization of the plugin goes here

	# ProjectSettings for first time
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
		"application/rakugo/scenes_links",
		"res://scenes_links.tres"
	)

	default_setting(
		"application/rakugo/save_folder",
		"saves"
	)

	default_setting(
		"application/rakugo/theme",
		"res://themes/new_gui/new_gui.theme"
	)

	default_setting(
		"application/rakugo/default_kind",
		"adv"
	)

	# Load the dock scene and instance it
	dock = preload("emojis/EmojiPanel.tscn").instance()

	# Add the loaded scene to the docks
	add_control_to_dock(DOCK_SLOT_RIGHT_UL, dock)
	# Note that LEFT_UL means the left of the editor, upper-left dock

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

	print("Rakugo is Active")

func _exit_tree():
	# Remove the dock
	remove_control_from_docks(dock)
	# Erase the control from the memory
	dock.free()

	remove_custom_type("RakugoVarHSlider")
	remove_custom_type("RakugoVarVSlider")
	remove_custom_type("RakugoHMenu")
	remove_custom_type("RakugoVMenu")
	remove_custom_type("RakugoVarCheckBox")
	remove_custom_type("RakugoVarCheckButton")
	remove_custom_type("RakugoProgressBar")
	remove_custom_type("RakugoTextureProgress")
