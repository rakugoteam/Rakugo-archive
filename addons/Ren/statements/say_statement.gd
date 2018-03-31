## This is RenAPI ##
## version: 0.5.0 ##
## License MIT ##
## Say statement class ##

extends "statement.gd"

var auto_enter = ["show", "hide", "notify"]

func _init():
	type = "say"
	kws = ["who", "what"]

func enter(dbg = true):
	if dbg:
		print(debug(kws))
	
	if "who" in kwargs:
		if kwargs.who in Ren.values:
			if Ren.get_value_type(kwargs.who) == "character":
				var who = Ren.get_value(kwargs.who)
				kwargs.who = who.parse_character()
				
				if "avatar" in Ren.get_value(org_kwargs.who).kwargs:
					kwargs["avatar"] = Ren.get_value(org_kwargs.who).avatar
				
				if "what" in kwargs:
					kwargs.what = who.parse_what(kwargs.what)
	
	if "who" in kwargs:
		kwargs.who = Ren.text_passer(kwargs.who)
	
	if "what" in kwargs:
		kwargs.what = Ren.text_passer(kwargs.what)
	
	.enter(false)

func on_exit(new_kwargs = {}):
	.on_exit(new_kwargs)
	
	if not (self in Ren.history):
		Ren.history.append(self)