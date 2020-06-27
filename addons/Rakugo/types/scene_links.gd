tool
extends Resource
class_name SceneLinks, "res://addons/Rakugo/icons/scene_links.svg"

export (Array, String) var ids := []
export (Array, PackedScene) var scenes := []
export var _dict := {}

func add(id:String, scene) -> void:
	if scene is String:
		_dict[id] = load(scene)

	else:
		_dict[id] = scene


func get_as_dict() -> Dictionary:
	if _dict.empty():
		for i in range(ids.size()):
			add(ids[i], scenes[i])

	return _dict


func set_using_dict(dictx:Dictionary) -> void:
	_dict = dictx.duplicate()
	ids = _dict.keys()
	scenes = _dict.values()


func set_using_arrays(_ids:Array, _scenes:Array) -> void:

	for i in range(_ids.size()):
		add(ids[i], scenes[i])

	ids = _dict.keys()
	scenes = _dict.values()
