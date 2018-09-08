extends "subquest.gd"

var subquests	= [] setget , _get_subquests
var rewards		= [] setget , _get_rewards # Maybe we need a Object Reward

signal start_quest
signal done_quest # when all quests is done
signal fail_quest # when fail the quest (all no optional quest)

# begin quest
func start():
	state = STATE_IN_PROGRESS
	emit_signal("start_quest")
	Ren.notifiy("You begin \"" + title + "\"")

# it adds a subquest to list
func add_subquest(subquest):
	subquests.append(subquest)
	subquest.connect("done_subquest", self, "_on_done_subquest")
	subquest.connect("fail_subquest", self, "_on_fail_subquest", [subquest])

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
	for subq in subquests:
		var is_done_and_opt = subq.is_done() and subq.is_optional()
		if not is_done_and_opt:
			return false
			
	return true

# Return the quest with his subquest as dictionary.
# This is util for a save with PersistenceNode
func quest2dict():
	var dict = subquest2dict()
	dict["subquests"] = subquests2list_of_ids()
	return dict

# It get a dictionary with the full quest.
# This is util for to use in run time.
func dict2quest(dict):
	dict2subquest(dict)
	if not dict.has("subquests"):
		return
	
	subquests = []
	fill_subquests(dict["subquests"])

# usefull for saveing
func subquests2list_of_ids():
	var list_of_ids = []
	for subq in subquests:
		list_of_ids.append(subq.quest_id)
	return list_of_ids

# usefull after loading quest
func get_subquests(list_of_subquests_ids):
	var new_subquests = []
	for subq_id in list_of_subquests_ids:
		var subquest = Ren.get_subquest(subq_id)
		new_subquests.append(subquest)
	
	return new_subquests

func add_rewards(reward):
	rewards.append(reward)
	
func _get_rewards():
	return rewards

func _on_done_subquest():
	emit_signal("done_subquest")
	
	if is_all_subquest_completed():
		emit_signal("done_quest")
	
func _on_fail_subquest(subquest):
	emit_signal("fail_subquest")
	
	if not subquest.is_optional:
		emit_signal("fail_quest")