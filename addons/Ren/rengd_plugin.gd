tool
extends EditorPlugin


func _enter_tree():
	## icons should be change
	
	## add RenMain as singleton in ProjectSettings
#	add_custom_type("RenMain", "Node", preload("main.gd"), preload("icon.svg"))
	#print(ProjectSettings.)
	
	## RenNodes:
	add_custom_type("Screen", "Control", preload("ren_node.gd"), preload("icon.svg"))
	add_custom_type("RenNode2D", "Node2D", preload("ren_node.gd"), preload("icon.svg"))
	add_custom_type("RenVisualInstance", "VisualInstance", preload("ren_node.gd"), preload("icon.svg"))
	
	## RenCharacter nodes:
	add_custom_type("Character", "Node", preload("character.gd"), preload("icon.svg"))
	add_custom_type("Character2D", "Node2D", preload("character.gd"), preload("icon.svg"))
	add_custom_type("Character3D", "VisualInstance", preload("character.gd"), preload("icon.svg"))
	print("RenGD is Active")
	
func _exit_tree():
	#remove_custom_type("RenMain")
	
	## RenNodes:
	remove_custom_type("Screen")
	remove_custom_type("RenNode2D")
	remove_custom_type("RenVisualInstance")
	
	## RenCharacter nodes:
	remove_custom_type("Character")
	remove_custom_type("Character2D")
	remove_custom_type("Character3D")
	