extends Node

var kws = ["name", "color", "prefix", "suffix", "avatar"]
var _color
var _avatar
var _id
var type setget _get_type
var value setget dict2character, character2dict

export(String) var character_id = ""
export(String) var character_name = ""
export(Color) var color = Color("#ffffff") setget _set_color, _get_color
export(String) var prefix = ""
export(String) var suffix = ""
export(PackedScene) var avatar setget _set_avatar, _get_avatar

func _ready():
	Ren.variables[character_id] = self
	Ren.debug(character2dict(), kws, "Add Character " + character_id + " with ")

func _set_character_id(id):
	if Ren.variables.has(_id):
		Ren.variables.erase(_id)
	_id = character_id
	Ren.variables[_id] = self

func _get_character_id():
	return _id

func _set_color(vcolor):
	_color = vcolor.to_html()

func _get_color():
	return _color

func _set_avatar(vavatar):
	_avatar = vavatar.resource_path
	
func _get_avatar():
	return _avatar

func parse_character():
	var ncharacter = ""
	
	if character_name != "":
		ncharacter = "{color=#" + color + "}"
		ncharacter += character_name
		ncharacter += "{/color}"
	
	return ncharacter

func parse_what(what):
	return prefix + what + suffix

func _get_type():
	return "character"

func character2dict():
	var dict = {}
	dict["name"]	= character_name
	dict["color"]	= _color
	dict["prefix"]	= prefix
	dict["suffix"]	= suffix
	dict["avatar"]	= _avatar

	return dict

func dict2character(dict):
	if dict.has("name"):
		character_name = dict.name
	if dict.has("color"):
		_color = dict.color
	if dict.has("prefix"):
		prefix = dict.prefix
	if dict.has("suffix"):
		suffix = dict.suffix
	if dict.has("avatar"):
		_avatar = dict.avatar
