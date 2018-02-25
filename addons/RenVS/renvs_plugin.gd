tool
extends EditorPlugin


func _enter_tree():
	#add_custom_type("RenSay","VisualScriptCustomNode",preload("say.gd"),preload("buttonicon.png"))
	#add_custom_type("Test","Node",preload("test.gd"),preload("buttonicon.png"))
	var vs=VisualScriptEditor
	vs.add_custom_node("Say","Ren",load("res://addons/RenVS/say.gd"))
	vs.add_custom_node("Input","Ren",load("res://addons/RenVS/input.gd"))
	vs.add_custom_node("New Character","Ren",load("res://addons/RenVS/new_char_vis.gd"))
	vs.add_custom_node("Ask","Ren",load("res://addons/RenVS/ask.gd"))
	vs.add_custom_node("Start","Ren",load("res://addons/RenVS/start.gd"))
	vs.add_custom_node("Notify","Ren",load("res://addons/RenVS/notify.gd"))
	print("Say added")
func _exit_tree():
	pass