tool
extends EditorPlugin


func _enter_tree():
	## icons should be change
	
	## add RenMain as singleton in ProjectSettings
	#print(ProjectSettings.)
	
	## RenNodes:
	add_custom_type("Screen", "Control", preload("ren_node.gd"), preload("icon.svg"))
	add_custom_type("RenNode2D", "Node2D", preload("ren_node.gd"), preload("icon.svg"))
	add_custom_type("RenVisualInstance", "VisualInstance", preload("ren_node.gd"), preload("icon.svg"))
	
	## RenCharacter nodes:
	add_custom_type("Character", "Node", preload("character.gd"), preload("icon.svg"))
	add_custom_type("Character2D", "Node2D", preload("character.gd"), preload("icon.svg"))
	add_custom_type("Character3D", "VisualInstance", preload("character.gd"), preload("icon.svg"))
	
	## RenControl nodes:
	add_custom_type("RenLineEdit", "LineEdit", preload("ren_line_edit.gd"), preload("ren_line_edit.svg"))
	add_custom_type("RenSayPanel", "Panel", preload("ren_say_panel.gd"), preload("ren_panel.svg"))
	add_custom_type("RenMenu", "VBoxContainer", preload("ren_menu.gd"), preload("ren_menu.svg"))
	add_custom_type("RenChoiceButton", "Button", preload("ren_choice_button.gd"), preload("ren_choice_button.svg"))
	add_custom_type("RenButton", "Button", preload("ren_button.gd"), preload("ren_button.svg"))
	add_custom_type("RenTextLabel", "RichTextLabel", preload("ren_label.gd"))
	add_custom_type("RenValLabel", "RenValLabel", preload("ren_val_label.gd"))
	
	print("RenGD is Active")
	
func _exit_tree():
	## RenNodes:
	remove_custom_type("Screen")
	remove_custom_type("RenNode2D")
	remove_custom_type("RenVisualInstance")
	
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
	
	