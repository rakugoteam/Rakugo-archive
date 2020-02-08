tool
extends HBoxContainer

export var menu_rect:Rect2

var editor : EditorInterface
onready var tscn_dialog = $FreePos/TscnDialog

var scene : String setget _set_scene, _get_scene
var id : String setget _set_id, _get_id

var menu_rect_offset : Rect2

func _ready() -> void:
	menu_rect_offset = menu_rect
	
	$Icon.texture = get_icon("PackedScene", "EditorIcons")
	$Choose.icon = get_icon("GuiDropdown", "EditorIcons")
	$Browse.icon = get_icon("InstanceOptions", "EditorIcons")
	$Remove.icon = get_icon("GuiClose", "EditorIcons")
	
	$Choose.connect("pressed", self, "_on_choose")
	$Choose/Menu.connect("index_pressed", self, "_on_item")
	$Choose/Menu.connect("id_pressed", self, "_on_item")
	$Browse.connect("pressed", self, "_on_browse")
	tscn_dialog.connect("confirmed", self, "_on_tscn_dialog")
	$Remove.connect("pressed", self, "_on_remove")


func _on_choose() -> void:
	$Choose/Menu.clear()
	
	for s in editor.get_open_scenes():
		$Choose/Menu.add_item(s)
	
	menu_rect = menu_rect_offset
	menu_rect.position.y += $Choose.rect_size.y
	menu_rect.position += $Choose.rect_global_position
	menu_rect.position.x -= menu_rect.size.x
	$Choose/Menu.popup(menu_rect)


func _set_scene(value:String) -> void:
	$SceneEdit.text = value


func _get_scene() -> String:
	return $SceneEdit.text


func _set_id(value:String) -> void:
	$IdEdit.text = value


func _get_id() -> String:
	return $IdEdit.text


func _on_item(index:int) -> void:
	_set_scene($Choose/Menu.get_item_text(index))


func _on_browse() -> void:
	tscn_dialog.popup()


func _on_tscn_dialog() -> void:
	_set_scene(tscn_dialog.current_path)


func _on_remove() -> void:
	queue_free()
