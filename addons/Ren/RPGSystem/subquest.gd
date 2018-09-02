extends Object # "ren_var.gd" # idk why ren_var.gd :S

var who = "id of quest giver" setget _set_who, _get_who
var title = "Quest Title" setget _set_title, _get_title
var description = "Overall description of quest." setget _set_title, _get_title
# is this subquest needed for finish whole quest
var optional = false setget _set_optional, _get_optional

# it can be "available", "not available", "in progress", "done", "fail"
enum {STATE_AVAILABLE, STATE_NOT_AVAILABLE, STATE_IN_PROGRESS, STATE_DONE, STATE_FAIL}
var state = STATE_AVAILABLE setget _set_state, _get_state

signal done_subquest
signal fail_subquest

func is_done():
	if state == STATE_DONE:
		return true
	
	return false
	
func _get_optional():
	return optional
	
func _set_optional(is_optional):
	optional = is_optional

# begin quest
func start():
	state = STATE_IN_PROGRESS
	Ren.notifiy("You begin \"" + title + "\"")

func _set_who(who_id):
	who = who_id

func _get_who():
	return who

func _set_title(val):
	title = val

func _get_title():
	return title

func _set_des(val):
	description = val

func _get_des():
	return description

func _set_state(val):
	state = val

func _get_state():
	return state

func done():
	state = STATE_DONE
	emit_signal("done_subquest")
	Ren.notifiy("You finish \"" + title + "\"")

func fail():
	state = STATE_FAIL
	emit_signal("fail")



