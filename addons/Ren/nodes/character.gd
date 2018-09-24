extends Node

var kws = ["name", "color", "prefix", "suffix", "avatar"]
var _color
var _avatar
var type setget _get_type
var value setget dict2character, character2dict

export(String) var character_id = ""
export(String) var character_name = ""
export(Color) var color = Color("#ffffff") setget set_color, get_color
export(String) var prefix = ""
export(String) var suffix = ""
export(PackedScene) var avatar setget set_avatar, get_avatar

func _ready():
	Ren.variables[character_id] = self
	# Ren.debug(kwargs, kws, "Add Character " + character_id + " with ")

func get_character_id():
	return character_id

func set_color(value):
	_color = value.to_html()

func get_color():
	return _color

func set_avatar(value):
	_avatar = value.resource_path
	
func get_avatar():
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
	return inst2dict(self)

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
		_avatar = dict._avatar
