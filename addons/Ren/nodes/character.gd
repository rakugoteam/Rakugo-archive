extends Node

var kwargs = {"name":"", "what_prefix":"", "what_suffix":"", "color":"white"}
var kws = ["name", "color", "what_prefix", "what_suffix", "avatar"]
var _color

export(String) var character_id = "" setget set_character_id, get_character_id
export(String) var character_name = "" setget set_character_name, get_character_name
export(Color) var color = Color("#ffffff") setget set_color, get_color
export(String) var prefix = "" setget set_prefix, get_prefix
export(String) var suffix = "" setget set_suffix, get_suffix
export(PackedScene) var avatar setget set_avatar, get_avatar

func _ready():
	Ren.character(character_id, kwargs, self)
	Ren.debug(kwargs, kws, "Add Character " + character_id + " with ")

func set_character_id(value):
	if character_id != value:
		Ren.variables.erase(character_id)
	
	character_id = value
	Ren.character(value, kwargs, self)

func get_character_id():
	return character_id

func set_character_name(value):
	set_kwargs({"name": value})

func get_character_name():
	return kwargs.name

func set_color(value):
	_color = value
	set_kwargs({"color":value.to_html()})

func get_color():
	return _color

func set_prefix(value):
	set_kwargs({"what_prefix":value})

func get_prefix():
	if kwargs.has("prefix"):
		return kwargs.prefix

func set_suffix(value):
	set_kwargs({"what_suffix":value})

func get_suffix():
	if kwargs.has("suffix"):
		return kwargs.suffix

func set_avatar(value):
	if value != null:
		set_kwargs({"avatar":value.resource_path})
	

func get_avatar():
	if kwargs.has("avatar"):
		return kwargs.avatar
	else:
		return ""

func set_kwargs(new_kwargs):
	# update character
	for kws in new_kwargs:
		kwargs[kws] = new_kwargs[kws]

func parse_character():
	var ncharacter = ""
	
	if "name" in kwargs:
		ncharacter = "{color=#" + kwargs.color + "}"
		ncharacter += kwargs.name
		ncharacter += "{/color}"
	
	return ncharacter

func parse_what(what):
	return kwargs.what_prefix + what + kwargs.what_suffix

