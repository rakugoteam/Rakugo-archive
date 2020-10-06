tool
extends Node
class_name CharacterNode, "res://addons/Rakugo/icons/rakugo_character.svg"

export var character_id := "" setget _set_character_id, _get_character_id
export var saveable := true setget _set_saveable, _get_saveable
export var character_name := "" setget _set_character_name, _get_character_name
export var color := Color("#ffffff") setget _set_color, _get_color
export var prefix := "" setget _set_prefix, _get_prefix
export var suffix := "" setget _set_suffix, _get_suffix
export var avatar: PackedScene setget _set_avatar, _get_avatar
export var icon: Image
export var show_parameters: Dictionary setget _set_show_parameters, _get_show_parameters
export var say_parameters: Dictionary setget _set_say_parameters, _get_say_parameters
export var variables := {} setget _set_variables, _get_variables

var vars := {} setget _set_variables, _get_variables

var character: Character
var _name := ""
var _color := Color("#ffffff")
var _avatar: PackedScene
var _icon: Image
var _prefix := ""
var _suffix := ""
var _id := ""
var _saveable := true
var _show_parameters := {}
var _say_parameters := {}
var _vars := {}

func _ready() -> void:
	_set_saveable(_saveable)

	if(!Engine.editor_hint):
		Rakugo.connect("started", self, "_on_start")


func _on_start() -> void:
	var dict := get_dict()
	character = Rakugo.character(_id, dict)
	var dbg = Rakugo.debug_dict(dict,
	 character.parameters_names, "Set Character with id: " + _id)


func _set_character_id(value: String) -> void:
	if Engine.editor_hint:
		_id = value
		return

	if Rakugo.variables.has(_id):
		Rakugo.variables.erase(_id)

	_id = value


func _get_character_id() -> String:
	return _id


func _set_saveable(value: bool):
	_saveable = value

	if Engine.editor_hint:
		return

	if _saveable:
		Rakugo.debug([name, "added to save"])


func _get_saveable() -> bool:
	return _saveable


func _set_character_name(value: String) -> void:
	_name = value

	if character:
		character.name = value


func _get_character_name() -> String:
	if character:
		if character.name:
			return character.name

	return _name


func _set_color(value: Color) -> void:
	_color = value

	if character:
		character.color = value.to_html()


func _get_color() -> Color:
	if character:
		if character.color:
			return Color(character.color)

	return _color


func _set_prefix(value: String) -> void:
	_prefix = value

	if character:
		character.prefix = value


func _get_prefix() -> String:
	if character:
		if character.prefix:
			return character.prefix

	return _prefix


func _set_suffix(value: String) -> void:
	_suffix = value

	if character:
		character.suffix = value


func _get_suffix() -> String:
	if character:
		if character.suffix:
			return character.suffix

	return _suffix

func _set_icon(value: Image) -> void:
	_icon = value
	
	if character:
		character.icon = value.resource_path


func _get_icon() -> Image:
	if character:
		_icon = load(character.icon)
	
	return _icon



func _set_avatar(value: PackedScene) -> void:
	_avatar = value

	if character:
		character.avatar = value


func _get_avatar() -> PackedScene:
	if character:
		if character.avatar != null:
			return character.avatar

	return _avatar


func _set_show_parameters(value: Dictionary) -> void:
	_show_parameters = value

	if character:
		character.show_parameters = value


func _get_show_parameters() -> Dictionary:
	if character:
		if character.show_parameters:
			return character.show_parameters
	return _show_parameters
	
func _set_say_parameters(value: Dictionary) -> void:
	_say_parameters = value

	if character:
		character.say_parameters = value


func _get_say_parameters() -> Dictionary:
	if character:
		if character.say_parameters:
			return character.say_parameters
	return _say_parameters


func _set_variables(value: Dictionary) -> void:
	_vars = value

	if character:
		character.vars = value


func _get_variables() -> Dictionary:
	if character:
		if character.vars:
			return character.vars

	return _vars

func get_dict() -> Dictionary:
	var dict := {}
	dict["name"]	= _name
	dict["color"]	= _color.to_html()
	dict["prefix"]	= _prefix
	dict["suffix"]	= _suffix

	if _avatar:
		dict["avatar"] = _avatar.resource_path

	dict["show_parameters"]	= _show_parameters
	dict["say_parameters"]	= _say_parameters
	dict["variables"]		= _vars
	

	return dict


func on_save() -> void:
	if _saveable:
		var dict := get_dict()
		Rakugo.character(_id, dict)


func on_load(game_version) -> void:
	if _saveable:
		character = Rakugo.get_var(_id)
