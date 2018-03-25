## This is RenAPI ##
## version: 0.5.0 ##
## License MIT ##
## Say statement class ##

extends "statement.gd"

var auto_enter = ["swho", "hide", "notify"]

var who = "" setget _set_who, _get_who
var what = "" setget _set_what, _get_what

func _init():
	type = "say"
	kws = ["who", "what"]

func _get_who():
	return kwargs.who

func _set_who(value):
	kwargs.who = value

func _get_what():
	return kwargs.what

func _set_what(value):
	kwargs.what = value

func enter(dbg = true):
	if dbg:
		print(debug(kws))
	
	if "who" in kwargs:
		if who in Ren.values:
			if Ren.get_value_type(who) == "character":
				var ch_id = who
				var who = Ren.get_value(who)
				who = who.parse_character()
				
				if "avatar" in Ren.get_value(ch_id).kwargs:
					kwargs["avatar"] = Ren.get_value(ch_id).avatar
				
				if "what" in kwargs:
					what = who.parse_what(what)
	
	if "who" in kwargs:
		who = Ren.text_passer(who)
	
	if "what" in kwargs:
		what = Ren.text_passer(what)
	
	return .enter(false)

func on_exit(new_kwargs = {}):
	.on_exit(new_kwargs)
	
	if not (self in Ren.history):
		Ren.history.append(self)