tool
extends VBoxContainer

export var scene_link_edit:PackedScene
export var box_path:NodePath

var editor:EditorInterface
var file_path:String
var scenes_links: ScenesLinks
var box:BoxContainer

func plugin_ready(_editor:EditorInterface) -> void:
	editor = _editor
	box = get_node(box_path)
	$Add.connect("pressed", self, "on_add")
	$ScenesLinksChooser.connect("open", self, "_on_open")
	$ScenesLinksChooser.connect("cancel", self, "_on_cancel")
	$ScenesLinksChooser.connect("apply", self, "_on_apply")
	$Control/FileDialog.connect("confirmed", self, "_on_file_dialog")


func on_add() -> void:
	add_sle("", "")


func add_sle(scene_id:String, scene_path:String):
	var nsle = scene_link_edit.instance()
	nsle.editor = editor
	nsle.scene = scene_path
	nsle.id = scene_id
	box.add_child(nsle)


func _on_cancel() -> void:
	_on_open(file_path)


func _on_open(_file_path:String) -> void:
	file_path = _file_path

	for ch in box.get_children():
		ch.queue_free()

	scenes_links = load(file_path)

	var sl_dict = scenes_links.get_as_dict()

	for i in range(sl_dict.size()):
		var scene_path = sl_dict.values()[i].resource_path
		add_sle(sl_dict.keys()[i], scene_path)


func _on_apply() -> void:
	var ids := []
	var scenes := []
	var exits := scenes_links != null

	for ch in box.get_children():
		ids.append(ch.id)
		scenes.append(ch.scene)
	
	if not exits:
		scenes_links = ScenesLinks.new()
	
	scenes_links.set_using_dict(ids, scenes)
	
	if not exits:
		$Control/FileDialog.popup()
		return 

	save_sl(file_path, scenes_links)


func save_sl(_file_path:String, _scenes_links:ScenesLinks): 
	var error := ResourceSaver.save(_file_path, _scenes_links)

	if error != OK:
		print("There was issue writing ScenesLinks to %s error_number: %s" % 
			[file_path, error])


func _on_file_dialog():
	file_path = $Control/FileDialog.current_path
	$ScenesLinksChooser/LineEdit.text = file_path
	save_sl(file_path, scenes_links)
