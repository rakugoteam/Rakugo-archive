tool
extends VBoxContainer

export var scene_link_edit:PackedScene

var editor:EditorInterface
var file_path:String
var scenes_links: ScenesLinks

onready var box : BoxContainer = $ScrollContainer/VBoxContainer
onready var tween : Tween = $Label/Tween
onready var fd : FileDialog = $Control/FileDialog
onready var le : LineEdit  = $ScenesLinksChooser/LineEdit

func _ready() -> void:
	for ch in box.get_children():
		ch.queue_free()

	$Add.icon = get_icon("CreateNewSceneFrom", "EditorIcons")

	$Add.connect("pressed", self, "on_add")
	$ScenesLinksChooser.connect("open", self, "_on_open")
	$ScenesLinksChooser.connect("new_file", self, "_on_new")
	$ScenesLinksChooser.connect("cancel", self, "_on_cancel")
	$ScenesLinksChooser.connect("apply", self, "_on_apply")
	$ScenesLinksChooser.connect("set_as_def", self, "notify",
	 ["Setted as Default "])
	fd.connect("confirmed", self, "_on_file_dialog")
	tween.connect("tween_all_completed", $Label, "hide")
	get_parent().connect("about_to_show", self, "_on_about_to_show")


func _on_about_to_show() -> void:
	$ScenesLinksChooser.load_cfg()


func plugin_ready(_editor:EditorInterface) -> void:
	editor = _editor


func notify(text:String) -> void:
	$Label.text = text
	var scolor = Color(0, 0, 0, 0)
	tween.interpolate_property(
		$Label, "modulate", scolor, Color.green,
		1, Tween.TRANS_LINEAR,Tween.EASE_IN)

	tween.interpolate_property(
		$Label, "modulate", Color.green, scolor,
		1, Tween.TRANS_LINEAR,Tween.EASE_IN, 0.7)

	$Label.show()
	tween.start()


func on_add() -> void:
	add_sle("", "")


func add_sle(scene_id:String, scene_path:String):
	var nsle = scene_link_edit.instance()
	nsle.editor = editor
	nsle.scene = scene_path
	nsle.id = scene_id
	box.add_child(nsle)
	prints("adds", scene_id, scene_path)


func _on_cancel() -> void:
	_on_open(file_path)
	notify("Reloaded")


func _on_new(_file_path:String) -> void:
	file_path = _file_path

	for ch in box.get_children():
		ch.queue_free()

	scenes_links = ScenesLinks.new()


func _on_open(_file_path:String) -> void:
	file_path = _file_path

	for ch in box.get_children():
		ch.queue_free()

	scenes_links = load(file_path)
	var sl_dict = scenes_links.get_as_dict()

	# prints("dict", sl_dict)

	for k in sl_dict.keys():
		var scene_path = sl_dict[k]

		if scene_path is PackedScene:
			scene_path = scene_path.resource_path

		add_sle(k, scene_path)


func _on_apply() -> void:
	var exits := scenes_links != null

	var dict := {}
	for ch in box.get_children():
		dict[ch.id] = ch.scene

	if not exits:
		scenes_links = ScenesLinks.new()

	scenes_links.set_using_dict(dict)

	save_sl(file_path, scenes_links)


func save_sl(_file_path:String, _scenes_links:ScenesLinks):
	var error := ResourceSaver.save(_file_path, _scenes_links)

	if error != OK:
		notify("error see console")
		print("There was issue writing ScenesLinks to %s error_number: %s" %
			[file_path, error])
		return

	notify("Saved")


func _on_file_dialog():
	_ready()
	file_path = fd.current_path
	le.text = file_path
	save_sl(file_path, scenes_links)
