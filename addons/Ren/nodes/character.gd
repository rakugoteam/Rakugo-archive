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

func set_character_id(variable):
	if character_id != variable:
		Ren.variables.erase(character_id)
	
	character_id = variable
	Ren.character(variable, kwargs, self)

func get_character_id():
	return character_id

func set_character_name(variable):
	set_kwargs({"name": variable})

func get_character_name():
	return kwargs.name

func set_color(variable):
	_color = variable
	set_kwargs({"color":variable.to_html()})

func get_color():
	return _color

func set_prefix(variable):
	set_kwargs({"what_prefix":variable})

func get_prefix():
	if kwargs.has("prefix"):
		return kwargs.prefix

func set_suffix(variable):
	set_kwargs({"what_suffix":variable})

func get_suffix():
	if kwargs.has("suffix"):
		return kwargs.suffix

func set_avatar(variable):
	if variable != null:
		set_kwargs({"avatar":variable.resource_path})
	

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

