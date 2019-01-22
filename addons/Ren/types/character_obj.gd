extends Object
class_name CharacterObject

var kws = ["name", "color", "prefix", "suffix", "avatar"]
var _color
var _avatar
var type setget , _get_type
var value setget dict2character, character2dict

var name = ""
var color = Color("#ffffff") setget _set_color, _get_color
var prefix = ""
var suffix = ""
var avatar setget _set_avatar, _get_avatar

func _set_color(vcolor):
	_color = vcolor

func _get_color():
	return _color.to_html()

func _set_avatar(vavatar):
	_avatar = vavatar.resource_path
	
func _get_avatar():
	return _avatar

func parse_character():
	var ncharacter = ""
	
	if name != "":
		ncharacter = "{color=#" + color + "}"
		ncharacter += name
		ncharacter += "{/color}"
	
	return ncharacter

func parse_what(what):
	return prefix + what + suffix

func _get_type():
	return Ren.Type.CHARACTER

func character2dict():
	var dict = {}
	dict["name"]	= name
	dict["color"]	= color
	dict["prefix"]	= prefix
	dict["suffix"]	= suffix
	dict["avatar"]	= _avatar

	return dict

func dict2character(dict):
	if dict.has("name"):
		name = dict.name
	if dict.has("color"):
		color = dict.color
	if dict.has("prefix"):
		prefix = dict.prefix
	if dict.has("suffix"):
		suffix = dict.suffix
	if dict.has("avatar"):
		_avatar = dict.avatar
