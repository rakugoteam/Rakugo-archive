tool
extends VBoxContainer

export var scene_link_edit:PackedScene

var editor:EditorInterface
var file_path:String
var scene_links: SceneLinks

onready var box : BoxContainer = $ScrollContainer/VBoxContainer
onready var tween : Tween = $Label/Tween
onready var fd : FileDialog = $Control/FileDialog
onready var le : LineEdit  = $SceneLinksChooser/LineEdit

func _ready() -> void:
	for ch in box.get_children():
		ch.queue_free()

	$Add.icon = get_icon("CreateNewSceneFrom", "EditorIcons")

	$Add.connect("pressed", self, "on_add")
	$SceneLinksChooser.connect("open", self, "_on_open")
	$SceneLinksChooser.connect("new_file", self, "_on_new")
	$SceneLinksChooser.connect("cancel", self, "_on_cancel")
	$SceneLinksChooser.connect("apply", self, "_on_apply")
	$SceneLinksChooser.connect("set_as_def", self, "notify", ["Setted as Default "])
	fd.connect("confirmed", self, "_on_file_dialog")
	get_parent().connect("about_to_show", self, "_on_about_to_show")


func _on_about_to_show() -> void:
	$SceneLinksChooser.load_cfg()


func plugin_ready(_editor:EditorInterface) -> void:
	editor = _editor


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
	$Label.notify("Reloaded")


func _on_new(_file_path:String) -> void:
	file_path = _file_path

	for ch in box.get_children():
		ch.queue_free()

	scene_links = SceneLinks.new()


func _on_open(_file_path:String) -> void:
	file_path = _file_path

	for ch in box.get_children():
		ch.queue_free()

	scene_links = load(file_path)
	var sl_dict = scene_links.get_as_dict()

	# prints("dict", sl_dict)

	for k in sl_dict.keys():
		var scene_path = sl_dict[k]

		if scene_path is PackedScene:
			scene_path = scene_path.resource_path

		add_sle(k, scene_path)


func _on_apply() -> void:
	var exits := scene_links != null

	var dict := {}
	for ch in box.get_children():
		dict[ch.id] = ch.scene

	if not exits:
		scene_links = SceneLinks.new()

	scene_links.set_using_dict(dict)

	save_sl(file_path, scene_links)


func save_sl(_file_path:String, _scene_links:SceneLinks):
	var error := ResourceSaver.save(_file_path, _scene_links)

	if error != OK:
		$Label.notify("error see console")
		print("There was issue writing SceneLinks to %s error_number: %s" %
			[file_path, error])
		return

	$Label.notify("Saved")


func _on_file_dialog():
	_ready()
	file_path = fd.current_path
	le.text = file_path
	save_sl(file_path, scene_links)
