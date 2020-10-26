tool
class_name Emojis#, "res://addons/Rakugo/emojis/icon.png"

var path_here = "res://addons/Rakugo/emojis/"
var json_path = path_here + "emojis.json"
var emojis_path = path_here + "%dx%d/%s.tres"
var emojis_dict:Dictionary
var code_to_name_emojis:Dictionary = {} setget dummy_set
var name_to_code_emojis:Dictionary = {} setget dummy_set


func _init():
	var content = get_file_content(json_path)
	var emojis_list = parse_json(content)
	init_emoji_dictionaries(emojis_list)


func get_file_content(path:String) -> String:
	var file = File.new()
	var error = file.open(path, file.READ)
	var content = ""
	if error == OK:
		content = file.get_as_text()
		file.close()
	return content


func init_emoji_dictionaries(list:Array):
	self.code_to_name_emojis = {}
	self.name_to_code_emojis = {}
	for group in list:
		for emoji in group.emojis:
			var name = emoji.shortname
			name = name.replace(":", "")
			name = name.replace("regional_indicator_", "")
			var value = emoji.hex
			self.name_to_code_emojis[name] = value
			self.code_to_name_emojis[value] = name


func get_path_to_emoji(id:String, size:int = 16) -> String:
	if id in name_to_code_emojis:
		return emojis_path % [size, size, name_to_code_emojis[id]]
	elif id in code_to_name_emojis:
		return emojis_path % [size, size, id]
	push_warning("Emoji '%s' not found." % [id, size])
	return ""


func get_emoji_bbcode(id:String, size:int = 16) -> String:
	var path = get_path_to_emoji(id, size)
	if path:
		return "[img]%s[/img]" % path
	push_warning("Emoji '%s' not found." % [id, size])
	return ""


func dummy_set(_value):
	pass
