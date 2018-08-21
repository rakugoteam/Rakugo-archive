extends "ren_var.gd"

var who = "id of quest giver" setget _set_who, _get_who
var title = "Quest Title" setget _set_title, _get_title
var description = "Overall description of quest." setget _set_title, _get_title
var optional = false # is this subquest needed for finish whole quest
var state = "available" setget _set_state, _get_state # it can be "available", "not available", "in progress", "done", "fail"
var subquests = [] setget _set_subquests, _get_subquests
# list subquests of which the quest consists
var kwargs = {
		"who":"",
		"title":"",
		"description":"",
		"optional":false,
		"state":"not available",
		"subquests": []
	}

func set_kwargs(new_kwargs):
	# update character
	for kws in new_kwargs:
		kwargs[kws] = new_kwargs[kws]

# begin quest
func start():
	state = "in_progress"

func _set_who(who_id):
	v.who = who_id

func _get_who():
	return v.who

func _set_title(val):
	v.title = val

func _get_title():
	return v.title

func _set_des(val):
	v.description = val

func _get_des():
	return v.description

func _set_state(val):
	v.state = val
	for s in subquests:
		var q = Ren.get_quest(s)
		if q.optional:
			continue
		
		q.state = val

func _get_state():
	return v.state

func _set_subquests(val):
	v.subquests = val

func _get_subquests():
	return v.subquests

# it adds subquest to subquests
func add(subquest_name):
	subquests.append(subquest_name)




