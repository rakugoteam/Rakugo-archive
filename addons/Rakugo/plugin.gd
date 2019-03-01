tool
extends EditorPlugin


func _enter_tree():
	## add Rakugo as singleton in ProjectSettings
#	ProjectSettings.add_singleton(Rakugo.tscn)


	## they must stay to don't make few times script that
	## is almost the same, but in to first lines diffRakugot 
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
		
	# add_custom_type(
	# 	"RakugoVarCheckBox",
	# 	"CheckBox",
	# 	preload("nodes/rakugo_var_check.gd"),
	# 	preload("icons/rakugo_check_box.svg")
	# 	)
	
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
	remove_custom_type("RakugoVarHSlider")
	remove_custom_type("RakugoVarVSlider")
	remove_custom_type("RakugoHMenu")
	remove_custom_type("RakugoVMenu")
	remove_custom_type("RakugoVarCheckBox")
	remove_custom_type("RakugoProgressBar")
	remove_custom_type("RakugoTextureProgress")