extends Node
class_name Character, "res://addons/Rakugo/icons/rakugo_character.svg"

var _character : CharacterObject
var _name : = ""
var _color : = Color("#ffffff")
var _avatar : PackedScene = PackedScene.new()
var _prefix : = ""
var _suffix : = ""
var _id : = ""

export var character_id : = "" setget _set_character_id, _get_character_id
export var character_name : = "" setget _set_character_name, _get_character_name
export var color : = Color("#ffffff") setget _set_color, _get_color
export var prefix : = "" setget _set_prefix, _get_prefix
export var suffix : = "" setget _set_suffix, _get_suffix
export var avatar : PackedScene = PackedScene.new() setget _set_avatar, _get_avatar

func _ready() -> void:
	Rakugo.connect("started", self, "_on_start")
	add_to_group("save", true)

func _on_start() -> void:	
	var dict : = get_dict()
	_character = Rakugo.character(_id, dict)		
	var dbg = Rakugo.debug_dict(dict, _character.parameters_names, "Set Character " + _id + " with ")

func _set_character_id(value : String) -> void:
	if Rakugo.variables.has(_id):
		Rakugo.variables.erase(_id)
		
	_id = value

func _get_character_id() -> String:
	return _id

func _set_character_name(value : String) -> void:
	_name = value
	if _character:
		_character.name = value

func _get_character_name() -> String:
	if _character:
		if _character.name:
			return _character.name
			
	return _name

func _set_color(value : Color) -> void:
	_color = value
	if _character:
		_character.color = value.to_html()

func _get_color() -> Color:
	if _character:
		if _character.color:
			return Color(_character.color)
			
	return _color

func _set_prefix(value : String) -> void:
	_prefix = value
	if _character:
		_character.prefix = value

func _get_prefix() -> String:
	if _character:
		if _character.prefix: 
			return _character.prefix
			
	return _prefix

func _set_suffix(value : String) -> void:
	_suffix = value
	if _character:
		_character.suffix = value

func _get_suffix() -> String:
	if _character:
		if _character.suffix:
			return _character.suffix
			
	return _suffix

func _set_avatar(value : PackedScene) -> void:
	_avatar = value
	
	if _character:
		_character.avatar = value
	
func _get_avatar() -> PackedScene:
	if _character:
		if _character.avatar != null:
			return _character.avatar
			
	return _avatar

func get_dict() -> Dictionary:
	var dict : = {}
	dict["name"]	= _name
	dict["color"]	= _color.to_html()
	dict["prefix"]	= _prefix
	dict["suffix"]	= _suffix
	dict["avatar"]	= _avatar.resource_path
	return dict
	
func on_save() ->void:
	var dict : = get_dict()
	Rakugo.character(_id, dict)

func on_load(game_version) -> void:
	_character = Rakugo.get_character(_id)