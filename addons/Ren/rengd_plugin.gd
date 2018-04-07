tool
extends EditorPlugin


func _enter_tree():
	## add RenMain as singleton in ProjectSettings
	#print(ProjectSettings.)
	
	## RenNodes:
	add_custom_type(
		"RenControl",
		"Control",
		preload("nodes/ren_node.gd"),
		preload("icons/ren_control.svg")
		)
	
	add_custom_type(
		"RenNode2D",
		"Node2D",
		preload("nodes/ren_node.gd"),
		preload("icons/ren_node2d.svg")
		)
	
	add_custom_type(
		"RenVisualInstance",
		"Spatial",
		preload("nodes/ren_node.gd"),
		preload("icons/ren_spatial.svg")
		)
	
	## RenCharacter nodes:
	add_custom_type(
		"Character",
		"Node",
		preload("nodes/character.gd"),
		preload("icons/ren_character.svg")
		)
	
	add_custom_type(
		"Character2D",
		"Node2D",
		preload("nodes/character.gd"),
		preload("icons/ren_character2d.svg")
		)
	
	add_custom_type(
		"Character3D",
		"Spatial",
		preload("nodes/character.gd"),
		preload("icons/ren_character3d.svg")
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
		"RenValLabel",
		"Label",
		preload("nodes/ren_val_label.gd"),
		preload("icons/ren_val_label.svg")
		)
	
	add_custom_type(
		"RenValEdit",
		"LineEdit",
		preload("nodes/ren_val_edit.gd"),
		preload("icons/ren_val_edit.svg")
		)
	
	add_custom_type(
		"RenValHSlider",
		"HSlider",
		preload("nodes/ren_val_slider.gd"),
		preload("icons/ren_val_h_slider.svg")
		)
	
	add_custom_type(
		"RenValVSlider",
		"VSlider",
		preload("nodes/ren_val_slider.gd"),
		preload("icons/ren_val_v_slider.svg")
		)
	
	add_custom_type(
		"RenProgressBar",
		"ProgressBar",
		preload("nodes/ren_val_range.gd"),
		preload("icons/ren_progress_bar.svg")
		)
	
	add_custom_type(
		"RenTextureProgress",
		"TextureProgress",
		preload("nodes/ren_val_range.gd"),
		preload("icons/ren_texture_progress.svg")
		)
	
	add_custom_type(
		"RenValCheckBox",
		"CheckBox",
		preload("nodes/ren_val_check.gd"),
		preload("icons/ren_check_box.svg")
		)
	
	add_custom_type(
		"RenValCheckButton",
		"CheckButton",
		preload("nodes/ren_val_check.gd"),
		preload("icons/ren_check_button.svg")
		)
	
	print("RenGD is Active")
	
func _exit_tree():
	## RenNodes:
	remove_custom_type("RenControl")
	remove_custom_type("RenNode2D")
	remove_custom_type("RenSpatial")
	
	## RenCharacter nodes:
	remove_custom_type("Character")
	remove_custom_type("Character2D")
	remove_custom_type("Character3D")
	
	## RenControl nodes:
	remove_custom_type("RenLineEdit")
	remove_custom_type("RenSayPanel")
	remove_custom_type("RenMenu")
	remove_custom_type("RenChoiceButton")
	remove_custom_type("RenButton")
	remove_custom_type("RenTextLabel")
	remove_custom_type("RenValLabel")
	remove_custom_type("RenValEdit")
	remove_custom_type("RenValHSlider")
	remove_custom_type("RenValVSlider")
	remove_custom_type("RenValCheckBox")
	remove_custom_type("RenValCheckButton")
	
	