extends Resource
class_name Save, "res://addons/Rakugo/icons/save.svg"

export var game_version := ""
export var rakugo_version := ""
export var history := {}
export var history_id := 0
export var scene := ""
export var data := {}


func _get(property):
	if property in self.get_property_list():
		return self[property]
	elif property in get_meta_list():
		return get_meta(property)
	
func _set(property, value):
	print(property)
	if property in self.get_property_list():
		print(self[property])
	else:
		self.set_meta(property, value)
	return true
