extends Node
class_name RakugoAvatar, "res://addons/Rakugo/icons/rakugo_avatar.svg"

signal on_substate(substate)

export (Array, String) var state setget _set_state, _get_state

var _state : = []

func _ready():
	connect("on_substate", self, "_on_substate")

func _set_state(state : Array) -> void:
	_state = state

	if _state == []:
		_state = ["default"]

	for s in _state:
		emit_signal("on_substate", s)

func _get_state() -> Array:
	return _state

func _on_substate(substate):
	pass
