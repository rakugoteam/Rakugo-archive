extends Object

var quest_id = "yet_another_quest" # id of quest in Ren.variables used for save/load
var title = "Quest Title" setget _set_title, _get_title
var description = "Overall description of quest." setget _set_title, _get_title
# is this subquest needed for finish whole quest
var optional = false setget _set_optional, _get_optional

enum {STATE_NOT_AVAILABLE, STATE_AVAILABLE, STATE_IN_PROGRESS, STATE_DONE, STATE_FAIL}
var state = STATE_AVAILABLE setget _set_state, _get_state

signal done_subquest
signal fail_subquest
signal optional_changed(is_optional)
signal title_changed(new_title)
signal description_changed(new_des)
signal state_changed(new_state)

func is_done():
	if state == STATE_DONE:
		return true
	
	return false
	
func _get_optional():
	return optional
	
func _set_optional(is_optional):
	optional = is_optional
	emit_signal("optional_changed", is_optional)

# begin quest
func start():
	state = STATE_IN_PROGRESS
	Ren.notifiy("You begin \"" + title + "\"")

func _set_title(new_title):
	title = new_title
	emit_signal("title_changed", new_title)

func _get_title():
	return title

func _set_des(new_des):
	description = new_des
	emit_signal("description_changed", new_des)

func _get_des():
	return description

func _set_state(new_state):
	state = new_state
	emit_signal("state_changed", new_state)

func _get_state():
	return state

func done():
	state = STATE_DONE
	emit_signal("done_subquest")
	Ren.notifiy("You finish \"" + title + "\"")

func fail():
	state = STATE_FAIL
	emit_signal("fail")

# Return the subquest as dictionary.
# This is util for a save with PersistenceNode
func subquest2dict():
	var dict = {}
	dict["quest_id"]	= quest_id
	dict["title"]		= title
	dict["description"]	= description
	dict["optional"]	= optional
	dict["state"]		= state
	return dict

# It get a dictionary with the subquest.
# This is util for to use in run time.
func dict2subquest(dict):
	if dict.has("quest_id"):
		quest_id	= dict["quest_id"]
	if dict.has("title"):
		title		= dict["title"]
	if dict.has("optional"):
		optional	= dict["optional"]
	if dict.has("state"):
		state		= dict["state"]