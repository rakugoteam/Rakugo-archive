tool
extends Node
class_name Character, "res://addons/Rakugo/icons/rakugo_character.svg"

export var character_id := "" setget _set_character_id, _get_character_id
export var saveable := true setget _set_saveable, _get_saveable
export var character_name := "" setget _set_character_name, _get_character_name
export var color := Color("#ffffff") setget _set_color, _get_color
export var prefix := "" setget _set_prefix, _get_prefix
export var suffix := "" setget _set_suffix, _get_suffix
export var avatar: PackedScene setget _set_avatar, _get_avatar
export (String, "adv", "top", "center", "left", "right", "nvl", "fullscreen") var kind: String setget _set_kind, _get_kind
export (String, "vertical", "horizontal", "grid") var mkind: String setget _set_mkind, _get_mkind
export (int, 0, 10) var mcolumns: int setget _set_mcolumns, _get_mcolumns
export (String, "top_left", "top_right", "bottom_left", "bottom_right", "center_left", "center_top", "center_right", "center_bottom", "center") var manchor:= "center" setget _set_manchor, _get_manchor
export var stats := {} setget _set_stats, _get_stats

var character: CharacterObject
var _name := ""
var _color := Color("#ffffff")
var _avatar: PackedScene
var _prefix := ""
var _suffix := ""
var _id := ""
var _saveable := true
var _kind := "adv"
var _mkind := "vertical"
var _mcolumns := 0
var _manchor := "center"
var _stats := {}

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


func _set_avatar(value: PackedScene) -> void:
	_avatar = value

	if character:
		character.avatar = value


func _get_avatar() -> PackedScene:
	if character:
		if character.avatar != null:
			return character.avatar

	return _avatar


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


func _set_mkind(value: String) -> void:
	_mkind = value

	if character:
		character.mkind = value


func _get_mkind() -> String:
	if _mkind == "":
		_mkind = ProjectSettings.get_setting(
			"application/rakugo/default_mkind"
		)

	if character:
		if character.mkind:
			return character.mkind

	return _mkind


func _set_mcolumns(value: int) -> void:
	_mcolumns = value

	if character:
		character.mcolumns = value


func _get_mcolumns() -> int:
	if _mcolumns == 0:
		_mcolumns = int(ProjectSettings.get_setting(
			"application/rakugo/default_mcolumns"
		))

	if character:
		if character.mcolumns:
			return character.mcolumns

	return _mcolumns


func _set_manchor(value: String) -> void:
	_manchor = value

	if character:
		character.manchor = value


func _get_manchor() -> String:
	if _manchor == "":
		_manchor = ProjectSettings.get_setting(
			"application/rakugo/default_manchor"
		)

	if character:
		if character.manchor:
			return character.manchor

	return _manchor


func _set_stats(value: Dictionary) -> void:
	_stats = value

	if character:
		character.stats = value


func _get_stats() -> Dictionary:
	if character:
		if character.stats:
			return character.stats

	return _stats

func get_dict() -> Dictionary:
	var dict := {}
	dict["name"]		= _name
	dict["color"]		= _color.to_html()
	dict["prefix"]	= _prefix
	dict["suffix"]	= _suffix

	if _avatar:
		dict["avatar"] = _avatar.resource_path

	dict["stats"]	= _stats
	dict["kind"]	= _kind

	return dict


func on_save() -> void:
	if _saveable:
		var dict := get_dict()
		Rakugo.character(_id, dict)


func on_load(game_version) -> void:
	if _saveable:
		character = Rakugo.get_var(_id)
