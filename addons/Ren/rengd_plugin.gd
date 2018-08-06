tool
extends EditorPlugin


func _enter_tree():
	## add RenMain as singleton in ProjectSettings
	#print(ProjectSettings.)
	
	## RenNodes:
	add_custom_type(
		"RenControl",
		"Control",
		preload("nodes/ren_control.gd"),
		preload("icons/ren_control.svg")
		)
	
	add_custom_type(
		"RenNode2D",
		"Node2D",
		preload("nodes/ren_node2d.gd"),
		preload("icons/ren_node2d.svg")
		)
	
	add_custom_type(
		"RenVisualInstance",
		"Spatial",
		preload("nodes/ren_visual_instance.gd"),
		preload("icons/ren_spatial.svg")
		)
	
	## RenCharacter node:
	add_custom_type(
		"Character",
		"Node",
		preload("nodes/character.gd"),
		preload("icons/ren_character.svg")
		)
	
	## RenControl nodes:
	add_custom_type(
		"RenLineEdit",
		"LineEdit",
		preload("nodes/ren_line_edit.gd"),
		preload("icons/ren_line_edit.svg")
		)
	
	add_custom_type(
		"RenSayPanel",
		"Panel",
		preload("nodes/ren_say_panel.gd"),
		preload("icons/ren_panel.svg")
		)
	
	add_custom_type(
		"RenMenu",
		"VBoxContainer",
		preload("nodes/ren_menu.gd"),
		preload("icons/ren_menu.svg")
		)
	
	add_custom_type(
		"RenChoiceButton",
		"Button",
		preload("nodes/ren_choice_button.gd"),
		preload("icons/ren_choice_button.svg")
		)
	
	add_custom_type(
		"RenButton",
		"Button",
		preload("nodes/ren_button.gd"),
		preload("icons/ren_button.svg")
		)
	
	add_custom_type(
		"RenTextLabel",
		"RichTextLabel",
		preload("nodes/ren_label.gd"),
		preload("icons/ren_text_label.svg")
		)
	
	add_custom_type(
		"RenVarLabel",
		"Label",
		preload("nodes/ren_var_label.gd"),
		preload("icons/ren_var_label.svg")
		)
	
	add_custom_type(
		"RenVarEdit",
		"LineEdit",
		preload("nodes/ren_var_edit.gd"),
		preload("icons/ren_var_edit.svg")
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
	
	add_custom_type(
		"RenVarCheckBox",
		"CheckBox",
		preload("nodes/ren_var_check.gd"),
		preload("icons/ren_check_box.svg")
		)
	
	add_custom_type(
		"RenVarCheckButton",
		"CheckButton",
		preload("nodes/ren_var_check.gd"),
		preload("icons/ren_check_button.svg")
		)

	add_custom_type(
		"RenAnimPlayer",
		"AnimationPlayer",
		preload("nodes/ren_anim_player.gd"),
		preload("icons/ren_anim_player.svg")
		)
	
	
	
	print("RenGD is Active")
	
func _exit_tree():
	## RenNodes:
	remove_custom_type("RenControl")
	remove_custom_type("RenNode2D")
	remove_custom_type("RenSpatial")
	
	## RenCharacter node:
	remove_custom_type("Character")

	## RenControl nodes:
	remove_custom_type("RenLineEdit")
	remove_custom_type("RenSayPanel")
	remove_custom_type("RenMenu")
	remove_custom_type("RenChoiceButton")
	remove_custom_type("RenButton")
	remove_custom_type("RenTextLabel")
	remove_custom_type("RenVarLabel")
	remove_custom_type("RenVarEdit")
	remove_custom_type("RenVarHSlider")
	remove_custom_type("RenVarVSlider")
	remove_custom_type("RenVarCheckBox")
	remove_custom_type("RenVarCheckButton")
	remove_custom_type("RenAnimPlayer")
	