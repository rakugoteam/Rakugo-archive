tool
extends Resource
class_name ScenesLinks, "res://addons/Rakugo/icons/scenes_links.svg"

export (Array, String) var ids := []
export (Array, PackedScene) var scenes := []

func get_as_dict() -> Dictionary:
	var dict := {}
	var r = ids.size()

	if r != scenes.size():
		print("id and scenes are in diffrent size!!!")
		r = min(r, scenes.size())
		prints("will return only", r, "links")

	for i in range(r):
		dict[ids[i]] = scenes[i]

	return dict

func set_using_dict(_ids:Array, _scenes:Array) -> void:
	ids = _ids
	for s in _scenes:
		var ps : PackedScene = load(s)
		scenes.append(ps)
