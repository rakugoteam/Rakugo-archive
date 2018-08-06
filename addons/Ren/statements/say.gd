extends "statement.gd"

func _init():
	._init()
	type = "say"
	kws += ["who", "what"]
	kwargs["who"] = ""
	kwargs["add_to_history"] = true

func exec(dbg = true):
	if dbg:
		print(debug(kws))
	
	if "who" in kwargs:
		if kwargs.who in Ren.variables:
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
