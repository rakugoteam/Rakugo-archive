tool
extends Node
class_name Character, "res://addons/Rakugo/icons/rakugo_character.svg"

var character: CharacterObject
var _name := ""
var _color := Color("#ffffff")
var _avatar: PackedScene
var _prefix := ""
var _suffix := ""
var _id := ""
var _stats := {}
var _kind := ""

export var character_id := "" setget _setcharacter_id, _getcharacter_id
export var character_name := "" setget _setcharacter_name, _getcharacter_name
export var color := Color("#ffffff") setget _set_color, _get_color
export var stats := {} setget _set_stats, _get_stats
export var prefix := "" setget _set_prefix, _get_prefix
export var suffix := "" setget _set_suffix, _get_suffix
export var avatar: PackedScene setget _set_avatar, _get_avatar
export var kind: String setget _set_kind, _get_kind

func _ready() -> void:
	if(!Engine.editor_hint):
		Rakugo.connect("started", self, "_on_start")

	add_to_group("save", true)


func _on_start() -> void:
	var dict := get_dict()
	character = Rakugo.character(_id, dict)
	var dbg = Rakugo.debug_dict(dict, character.parameters_names, "Set Character " + _id + " with ")


func _setcharacter_id(value: String) -> void:
	if(Engine.editor_hint):
		_id = value
		return

	if Rakugo.variables.has(_id):
		Rakugo.variables.erase(_id)

	_id = value


func _getcharacter_id() -> String:
	return _id


func _setcharacter_name(value: String) -> void:
	_name = value

	if character:
		character.name = value


func _getcharacter_name() -> String:
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


func _set_avatar(value: PackedScene) -> void:
	_avatar = value

	if character:
		character.avatar = value


func _get_avatar() -> PackedScene:
	if character:
		if character.avatar != null:
			return character.avatar

	return _avatar


func _set_stats(value: Dictionary) -> void:
	_stats = value

	if character:
		character.stats = value


func _get_stats() -> Dictionary:
	if character:
		if character.stats:
			return character.stats

	return _stats


func _set_kind(value: String) -> void:
	_kind = value

	if character:
		character.kind = value


func _get_kind() -> String:
	if _kind == "":
		_kind = ProjectSettings.get_setting(
			"application/rakugo/default_kind"
		)

	if character:
		if character.kind:
			return character.kind

	return _kind


func get_dict() -> Dictionary:
	var dict := {}
	dict["name"]	= _name
	dict["color"]	= _color.to_html()
	dict["prefix"]	= _prefix
	dict["suffix"]	= _suffix

	if _avatar:
		dict["avatar"]	= _avatar.resource_path

	dict["stats"]	= _stats
	dict["kind"]	= _kind

	return dict


func on_save() -> void:
	var dict := get_dict()
	Rakugo.character(_id, dict)


func on_load(game_version) -> void:
	character = Rakugo.get_var(_id)


func _exit_tree() -> void:
	if(Engine.editor_hint):
		remove_from_group("save")
		return
