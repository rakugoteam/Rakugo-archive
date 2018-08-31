extends "quest.gd"

var subquests = [] setget _set_subquests, _get_subquests

func _init():
	kwargs["subquests"] = []

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




