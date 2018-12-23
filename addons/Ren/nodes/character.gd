extends Node

var _character
var _name = ""
var _color = Color("#ffffff")
var _avatar = PackedScene.new()
var _prefix = ""
var _suffix = ""
var _id = ""

export(String) var character_id = "" setget _set_character_id, _get_character_id
export(String) var character_name = "" setget _set_character_name, _get_character_name
export(Color) var color = Color("#ffffff") setget _set_color, _get_color
export(String) var prefix = "" setget _set_prefix, _get_prefix
export(String) var suffix = "" setget _set_suffix, _get_suffix
export(PackedScene) var avatar = PackedScene.new() setget _set_avatar, _get_avatar

func _ready():
	Ren.connect("started", self, "_on_start")

func _on_start():
	var dict = get_dict()
	_character = Ren.character(_id, dict)
	var dbg = Ren.debug_dict(dict, _character.kws, "Set Character " + _id + " with ")
	Ren.debug(dbg)

func _set_character_id(value):
	if Ren.variables.has(_id):
		Ren.variables.erase(_id)
	_id = value
	_on_start()

func _get_character_id():
	return _id

func _set_character_name(value):
	_name = value
	if _character != null:
		_character.name = value

func _get_character_name():
	if _character != null:
		if _character.name != null:
			return _character.name
	return _name

func _set_color(value):
	_color = value
	if _character != null:
		_character.color = value 

func _get_color():
	if _character != null:
		if _character.color != null:
			return _character.color
	return _color

func _set_prefix(value):
	_prefix = value
	if _character != null:
		_character.prefix = value

func _get_prefix():
	if _character != null:
		if _character.prefix != null: 
			return _character.prefix
	return _prefix

func _set_suffix(value):
	_suffix = value
	if _character != null:
		_character.suffix = value

func _get_suffix():
	if _character != null:
		if _character.suffix != null:
			return _character.suffix
	return _suffix

func _set_avatar(value):
	_avatar = value
	if _character != null:
		_character.avatar = value
	
func _get_avatar():
	if _character != null:
		if _character.avatar != null:
			return _character.avatar
	return _avatar

func get_dict():
	var dict = {}
	dict["name"]	= _name
	dict["color"]	= _color.to_html()
	dict["prefix"]	= _prefix
	dict["suffix"]	= _suffix
	dict["avatar"]	= _avatar.resource_path
	return dict