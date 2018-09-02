extends Object # "ren_var.gd" # idk why ren_var.gd :S

var who = "ID of quest giver" setget _set_who, _get_who
var title = "Quest Title" setget _set_title, _get_title
var description = "Overall description of quest." setget _set_title, _get_title
var subquests = [] setget , _get_subquests
var rewards = [] setget , _get_rewards # Maybe we need a Object Reward

enum {STATE_AVAILABLE, STATE_NOT_AVAILABLE, STATE_IN_PROGRESS, STATE_DONE, STATE_FAIL}
var state = STATE_AVAILABLE setget _set_state, _get_state

signal start_quest
signal done_quest # when all quests is done
signal done_subquest # when one quest is done
signal fail_quest # when fail the quest (all no optional quest)
signal fail_subquest # when fail a subquest

# begin quest
func start():
	state = STATE_IN_PROGRESS
	emit_signal("start_quest")
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

# he get a subquest 
func _add_subquest(subquest):
	subquest.append(subquest)
	subquest.connect("done_subquest", self, "_on_done_subquest")
	subquest.connect("fail_subquest", self, "_on_fail_subquest")

func _get_subquests(index):
	return subquests[index]

# force finish quest
func finish():
	if is_all_subquest_completed():
		state = STATE_DONE
		emit_signal("done_quest")
	else:
		state = STATE_FAIL
		emit_signal("fail_quest")

func is_all_subquest_completed():
	for subquest in subquests:
		if not subquest.is_done() and not subquest.is_optional():
			return false
			
	return true

# Return the quest with his subquest in a dictionary.
# This is util for a save with PersistenceNode
func quest2dict():
	pass # NEEDIMPLEMENT

# He get a dictionary with the full quest.
# This is util for to use in run time.
func dict2quest(dict):
	pass # NEEDIMPLEMENT

func add_rewards(reward):
	rewards.append(reward)
	
func _get_rewards():
	return rewards

func _on_done_subquest():
	emit_signal("done_subquest")
	
	if is_all_subquest_completed():
		emit_signal("done_quest")
	
func _on_fail_subquest():
	emit_signal("fail_subquest")
	
	if is_all_subquest_completed():
		emit_signal("fail_quest")