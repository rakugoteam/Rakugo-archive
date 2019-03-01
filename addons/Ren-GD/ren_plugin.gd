tool
extends EditorPlugin


func _enter_tree():
	## add Ren as singleton in ProjectSettings
#	ProjectSettings.add_singleton(Ren.tscn)


	## they must stay to don't make few times script that
	## is almost the same, but in to first lines diffrent 
	add_custom_type(
		"VRenMenu",
		"VBoxContainer",
		preload("nodes/ren_menu.gd"),
		preload("icons/ren_menu_v.svg")
		)
	
	add_custom_type(
		"HRenMenu",
		"HBoxContainer",
		preload("nodes/ren_menu.gd"),
		preload("icons/ren_menu_h.svg")
		)
		
	add_custom_type(
		"RenVarCheckBox",
		"CheckBox",
		preload("nodes/ren_var_check.gd"),
		preload("icons/ren_check_box.svg")
		)
	
	add_custom_type(
		"RenVarHSlider",
		"HSlider",
		preload("nodes/ren_var_slider.gd"),
		preload("icons/ren_var_h_slider.svg")
		)
	
	add_custom_type(
		"RenVarVSlider",
		"VSlider",
		preload("nodes/ren_var_slider.gd"),
		preload("icons/ren_var_v_slider.svg")
		)
	
	add_custom_type(
		"RenProgressBar",
		"ProgressBar",
		preload("nodes/ren_var_range.gd"),
		preload("icons/ren_progress_bar.svg")
		)
	
	add_custom_type(
		"RenTextureProgress",
		"TextureProgress",
		preload("nodes/ren_var_range.gd"),
		preload("icons/ren_texture_progress.svg")
		)
	
	print("Ren is Active")
	
func _exit_tree():
	remove_custom_type("RenVarHSlider")
	remove_custom_type("RenVarVSlider")
	remove_custom_type("RenHMenu")
	remove_custom_type("RenVMenu")
	remove_custom_type("RenVarCheckBox")
	remove_custom_type("RenProgressBar")
	remove_custom_type("RenTextureProgress")