extends Node
class_name GDScriptDialog

export var root = false
export (Array, String) var begin_from = []
export (Array, String) var dialog_names = []

func _ready() -> void:
	if Rakugo.current_root_node != self and root:
		Rakugo.current_root_node = self

	if begin_from != []:
		Rakugo.begin(begin_from[0], name, begin_from[1])
		Rakugo.add_dialog(self, begin_from[1])

	for dn in dialog_names:
		Rakugo.add_dialog(self, dn)

func get_story_state() -> int:
	return Rakugo.story_state

func check_dialog(node_name, dialog_name, check_for) -> bool:
	if node_name != name:
		return false

	if dialog_name != check_for:
		return false

	return true

func define(var_name:String, value = null, save_included := true) -> RakugoVar:
	return Rakugo.define(var_name, value, save_included)

func ranged_var(var_name, start_value := 0.0, min_value := 0.0, max_value := 0.0) -> RakugoRangedVar:
	return Rakugo.ranged_var(var_name, start_value, min_value, max_value)

func character(character_id:String, parameters:={}) -> CharacterObject:
	return Rakugo.character(character_id, parameters)

func set_var(var_name:String, value) -> RakugoVar:
	return Rakugo.set_var(var_name, value)

func get_var(var_name:String) -> RakugoVar:
	return Rakugo.get_var(var_name)

func get_value(var_name:String):
	return Rakugo.get_value(var_name)

func subquest(subquest_id:String, parameters:= {}) -> Subquest:
	return Rakugo.subquest(subquest_id, parameters)

func quest(quest_id:String, parameters:={}) -> Quest:
	return Rakugo.quest(quest_id, parameters)

func say(parameters:Dictionary) -> void:
	Rakugo.say(parameters)

func ask(parameters:Dictionary) -> void:
	Rakugo.ask(parameters)

func menu(parameters:Dictionary) -> void:
	Rakugo.menu(parameters)

func show(node_id:String, parameters := {"state": [], "at":["center", "bottom"]}):
	Rakugo.show(node_id, parameters)

func hide(node_id:String) -> void:
	Rakugo.hide(node_id)

func notifiy(info:String, length:int = get_value("notify_time")) -> void:
	Rakugo.notifiy(info, length)

func play_anim( node_id:String, anim_name:String) -> void:
	Rakugo.play_anim(node_id, anim_name)

func stop_anim(node_id:String, reset:= true) -> void:
	Rakugo.stop_anim(node_id, reset)

func play_audio(node_id:String, from_pos:= 0.0) -> void:
	Rakugo.play_audio(node_id, from_pos)

func stop_audio(node_id:String) -> void:
	Rakugo.stop_audio(node_id)

func call_node(node_id:String, func_name:String, args:= []) -> void:
	Rakugo.call_node(node_id, func_name, args)

func jump(id_of_scene:String, node_name:String, dialog_name:String, change:= true) -> void:
	Rakugo.jump(id_of_scene, node_name, dialog_name, change)
