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
	Ren.notifiy("You begin \"" + title + "\"")

func _set_who(who_id):
	kwargs.who = who_id
	value = kwargs

func _get_who():
	return kwargs.who
	value = kwargs

func _set_title(val):
	kwargs.title = val
	value = kwargs

func _get_title():
	return kwargs.title

func _set_des(val):
	kwargs.description = val
	value = kwargs

func _get_des():
	return kwargs.description

func _set_state(val):
	kwargs.state = val
	value = kwargs

func _get_state():
	return kwargs.state

func _set_subquests(val):
	kwargs.subquests = val
	value = kwargs

func _get_subquests():
	return kwargs.subquests

# it adds subquest to subquests
func add(subquest_name):
	subquests.append(subquest_name)

func done():
	state = "done"
	for s in subquests:
		var q = Ren.get_quest(s)
		if q.optional:
			continue
		
		q.state = "done"
	Ren.notifiy("You finish \"" + title + "\"")




