tool
extends HBoxContainer

onready var tscn_dialog = $FreePos/TscnDialog

var scene : String setget _set_scene, _get_scene
var id : String setget _set_id, _get_id

func _ready() -> void:
	$Choose.connect("pressed", self, "_on_choose")
	$Choose/Menu.connect("index_pressed", self, "_on_item")
	$Browse.connect("pressed", self, "_on_browse")
	tscn_dialog.connect("confirmed", self, "_on_tscn_dialog")
	$Remove.connect("pressed", self, "_on_remove")

func _on_choose() -> void:
	# add items
	$Choose/Menu.popup()


func _set_scene(value:String) -> void:
	$SceneEdit.text = value


func _get_scene() -> String:
	return $SceneEdit.text


func _set_id(value:String) -> void:
	$IdEdit.text = value


func _get_id() -> String:
	return $IdEdit.text


func _on_item(index:int) -> void:
	scene = $Choose/Menu.items[index]


func _on_browse() -> void:
	tscn_dialog.popup()


func _on_tscn_dialog() -> void:
	scene = tscn_dialog.current_path


func _on_remove() -> void:
	queue_free()