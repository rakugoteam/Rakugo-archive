## This is Ren'GD API ##

## version: 0.7 ##
## License MIT ##

extends Node

var dialog_name
var current_scene
var current_scene_path
var node_path
var func_name

var dialogs = {}

signal enter_dialog

func _Edialog(dialog):
	print(dialog, " is not definited")


func _dialog(dialog, sc_path, n_path = "", f_name = ""):
	dialog_name = dialog
	current_scene_path = sc_path
	node_path = n_path
	func_name = f_name


func dialog(dialog, sc_path, n_path = "", f_name = ""):
	_dialog(dialog, sc_path, n_path, f_name)
	dialogs[dialog] = {"scene_path":sc_path, "node_path":n_path, "func_name":f_name}


func set_current_dialog(dialog):
	if dialog in dialogs.keys():
		var l = dialogs[dialog]
		_dialog(dialog, l.scene_path, l.node_path, l.func_name)
		print("set_current_dialog as ", dialog, ", ", l.scene_path, ", ", l.node_path, ", ", l.func_name)
	
	else:
		_Edialog(dialog)


## code borrow from:
## http://docs.godotengine.org/en/stable/tutorials/step_by_step/singletons_autoload.html
func goto_scene(path):

	## This function will usually be called from a signal callback,
	## or some other function from the running scene.
	## Deleting the current scene at this point might be
	## a bad idea, because it may be inside of a callback or function of it.
	## The worst case will be a crash or unexpected behavior.

	## The way around this is deferring the load to a later time, when
	## it is ensured that no code from the current scene is running:

	call_deferred("_deferred_goto_scene", path)


## code borrow from:
## http://docs.godotengine.org/en/stable/tutorials/step_by_step/singletons_autoload.html
func _deferred_goto_scene(path):

	## Immediately free the current scene,
	## there is no risk here.
	current_scene.free()

	## Load new scene
	var s = load(path)

	## Instance the new scene
	current_scene = s.instance()

	## Add it to the active scene, as child of root
	get_tree().get_root().add_child(current_scene)

	## optional, to make it compatible with the SceneTree.change_scene() API
	get_tree().set_current_scene(current_scene)


func jump(dialog, args = []):

	if dialog in dialogs.keys():
	
		var vdialog = dialogs[dialog]
		dialog_name = dialog

		if current_scene_path != vdialog.scene_path:
			goto_scene(vdialog.scene_path)
			current_scene_path = vdialog.scene_path

		print("old node path: ", node_path)

		if vdialog.node_path == "": ## asume that developer want to use root of scene
			node_path = get_node_path(current_scene)

		elif node_path == vdialog.node_path:
			pass

		else:
			node_path = vdialog.node_path

		print("new node path: ", node_path)

		func_name = vdialog.func_name
		
		if func_name != "": ## else asume that developer want to use _ready as dialog
			connect("enter_dialog", get_node(node_path), func_name, args)
			emit_signal("enter_dialog")
	
	else:
		print(dialog, " is not definited")


func statement(dialog, args = []):
	## return jump statement
	return {"type":"jump", "dialog":dialog, "args":args}


func use(statement):
	## use jump statement
	jump(statement.dialog, statement.args)