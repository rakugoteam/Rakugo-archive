extends RakugoVar
class_name Subquest

var title: String = "Quest Title" setget _set_title, _get_title
var description: String = "Overall description of quest." setget _set_title, _get_title
# is this subquest needed for finish whole quest
var optional: bool = false setget _set_optional, _get_optional

enum {STATE_NOT_AVAILABLE, STATE_AVAILABLE, STATE_IN_PROGRESS, STATE_DONE, STATE_FAIL}
var state: int = STATE_AVAILABLE setget _set_state, _get_state

signal done_subquest
signal fail_subquest
signal optional_changed(is_optional)
signal title_changed(new_title)
signal description_changed(new_des)
signal state_changed(new_state)

func _init(var_id:String, var_value:Dictionary, var_type :=Rakugo.Type.SUBQUEST
		).(var_id, var_value, var_type) -> void:
	_set_value(_value)


func _set_value(parameters := {}) -> void:
	dict2subquest(parameters)


func _get_value() -> Dictionary:
	return subquest2dict()


func is_done() -> bool:
	return state == STATE_DONE


func _get_optional() -> bool:
	return optional


func _set_optional(is_optional) -> void:
	optional = is_optional
	emit_signal("optional_changed", is_optional)


# begin quest
func start() -> void:
	state = STATE_IN_PROGRESS
	Rakugo.notify("You begin \"" + title + "\"")


func _set_title(new_title: String) -> void:
	title = new_title
	emit_signal("title_changed", new_title)


func _get_title() -> String:
	return title


func _set_des(new_des: String) -> void:
	description = new_des
	emit_signal("description_changed", new_des)


func _get_des() -> String:
	return description


func _set_state(new_state: int) -> void:
	state = new_state
	emit_signal("state_changed", new_state)


func _get_state() -> int:
	return state


func done() -> void:
	state = STATE_DONE
	emit_signal("done_subquest")
	Rakugo.notify("You finish \"" + title + "\"")


func fail() -> void:
	state = STATE_FAIL
	emit_signal("fail_subquest")


# Return the subquest as dictionary.
# This is util for a save with PersistenceNode
func subquest2dict() -> Dictionary:
	var dict = {}
	dict["title"]		= title
	dict["description"]	= description
	dict["optional"]	= optional
	dict["state"]		= state
	return dict


# It get a dictionary with the subquest.
# This is util for to use in run time.
func dict2subquest(dict: Dictionary) -> void :
	if dict.has("title"):
		title = dict["title"]

	if dict.has("optional"):
		optional = dict["optional"]

	if dict.has("state"):
		state = dict["state"]
