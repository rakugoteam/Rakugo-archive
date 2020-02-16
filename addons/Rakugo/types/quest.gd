extends Subquest
class_name Quest

var _subquests: Array = []

## wip
var rewards: Array	= [] setget, _get_rewards # Maybe we need a Object Reward

signal start_quest
signal done_quest # when all quests is done
signal fail_quest # when fail the quest (all no optional quest)

func _init(var_id: String, var_value: Dictionary
		).(var_id, var_value, Rakugo.Type.QUEST) -> void:
	pass


func _set_value(parameters := {}) -> void:
	dict2quest(parameters)


func _get_value() -> Dictionary:
	return quest2dict()


# begin quest
func start() -> void:
	state = STATE_IN_PROGRESS
	emit_signal("start_quest")
	Rakugo.notify("You begin \"" + title + "\"")


# it adds a subquest to list
func add_subquest(subquest: Subquest) -> void:
	_subquests.append(subquest)
	subquest.connect("done_subquest", self, "_on_done_subquest")
	subquest.connect("fail_subquest", self, "_on_fail_subquest", [subquest])


func get_subquest(index: int) -> Subquest:
	return _subquests[index]


func get_subquests() -> Array:
	return _subquests


func is_subquests_empty() -> bool:
	return _subquests.empty()


# force finish quest
func finish() -> void:
	if is_all_subquest_completed():
		state = STATE_DONE
		emit_signal("done_quest")

	else:
		state = STATE_FAIL
		emit_signal("fail_quest")


func is_all_subquest_completed() -> bool:
	for subq in _subquests:
		var is_done_and_opt = (
			subq.is_done()
			and subq.is_optional()
			)

		if not is_done_and_opt:
			return false

	return true


# Return the quest with his subquest as dictionary.
# This is util for a save with PersistenceNode
func quest2dict() -> Dictionary:
	var dict = subquest2dict()
	dict["subquests"] = subquests2list_of_ids()
	return dict


# It get a dictionary with the full quest.
# This is util for to use in run time.
func dict2quest(dict: Dictionary) -> void:
	dict2subquest(dict)
	if not dict.has("subquests"):
		return

	_subquests = get_subquests_list(dict["subquests"])


# usefull for saveing
func subquests2list_of_ids() -> Array:
	var list_of_ids := []

	for subq in _subquests:
		list_of_ids.append(subq.quest_id)

	return list_of_ids


# useful after loading quest
func get_subquests_list(list_of_subquests_ids: Array) -> Array:
	var new_subquests := []

	for subq_id in list_of_subquests_ids:
		if typeof(subq_id) != TYPE_STRING:
			continue

		var subquest = Rakugo.get_var(subq_id)
		new_subquests.append(subquest)

	return new_subquests


func update_subquests() -> void:
	_subquests = get_subquests_list(_subquests)


## wip
func add_rewards(reward) -> void:
	rewards.append(reward)


## wip
func _get_rewards():
	return rewards


func _on_done_subquest() -> void:
	emit_signal("done_subquest")

	if is_all_subquest_completed():
		emit_signal("done_quest")


func _on_fail_subquest(subquest: Subquest) -> void:
	emit_signal("fail_subquest")

	if not subquest.is_optional:
		emit_signal("fail_quest")
