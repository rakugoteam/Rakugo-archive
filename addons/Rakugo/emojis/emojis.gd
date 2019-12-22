tool
extends Node
class_name Emojis, "res://addons/Rakugo/emojis/16x16/1f600.png"

var path_here = "res://addons/Rakugo/emojis/"
var json_path = path_here + "emojis.json"
var emojis_dict: Dictionary

func _ready():
	var content := get_file_content(json_path)
	var emojis_list: Array = parse_json(content)
	emojis_dict = emoji_list_to_dict(emojis_list)


func get_file_content(path: String) -> String:
	var file = File.new()
	var error: int = file.open(path, file.READ)
	var content := ""
	
	if error == OK:
		content = file.get_as_text()
		file.close()
		
	return content


func emoji_list_to_dict(list: Array) -> Dictionary:
	var dict := {}
	for group in list:
		for emoji in group.emojis:
			var key: String = emoji.shortname
			key = key.replace(":", "")
			key = key.replace("regional_indicator_", "")
			var value: String = emoji.hex
			dict[key] = value
	
	return dict


func get_path_to_emoji(emoji_name: String, size := 16) -> String:
	var size_dir := str(size) + "x" + str(size) + "/"
	var emoji_png: String = emojis_dict[emoji_name] + ".png" 
	return path_here + size_dir + emoji_png
