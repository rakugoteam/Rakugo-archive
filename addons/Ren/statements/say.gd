extends "statement.gd"


func _init():
	type = "say"
	kws = ["who", "what"]

func exec(dbg = true):
	if dbg:
		print(debug(kws))
	
	if "who" in kwargs:
		if kwargs.who in Ren.values:
			if Ren.get_value_type(kwargs.who) == "character":
				var org_who = kwargs.who
				var who = Ren.get_value(org_who)
				kwargs.who = who.parse_character()
				
				if "avatar" in Ren.get_value(org_who).kwargs:
					kwargs["avatar"] = Ren.get_value(org_who).avatar
				
				if "what" in kwargs:
					kwargs.what = who.parse_what(kwargs.what)
	
	if "who" in kwargs:
		kwargs.who = Ren.text_passer(kwargs.who)
	
	if "what" in kwargs:
		kwargs.what = Ren.text_passer(kwargs.what)
	
	.exec(false)

func on_exit(_type, new_kwargs = {}):
	if !setup_exit(_type, new_kwargs):
		return
	
	if Ren.current_id < 0 or Ren.current_id > Ren.history.size() + 1:
		prints("some thing gone wrong Ren.current_id =", Ren.current_id)
		prints("history size:", Ren.history.size())
		return
		
	var history_item = {
		"state": Ren.story_state,
		"statement":{
			"type": type,
			"kwargs": kwargs.duplicate()
		}
	}

	if Ren.current_id == Ren.history.size():
		Ren.history.append(history_item)

	else:
		Ren.history[Ren.current_id] = history_item

	Ren.current_id += 1
	
	Ren.story_step()