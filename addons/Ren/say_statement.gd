## This is RenAPI ##
## version: 0.5.0 ##
## License MIT ##
## Say statement class ##

extends "statement.gd"

var auto_enter = ["show", "hide", "notify"]

func _init():
	type = "say"
	kws = ["how", "what"]

func enter(dbg = true):
	if dbg:
		print(debug(kws))
	
	if "how" in kwargs:
		if kwargs.how in Ren.values:
			if Ren.values[kwargs.how].type == "character":
				var how = Ren.values[kwargs.how].value
				kwargs.how = how.parse_character()
				
				if "avatar" in Ren.values[org_kwargs.how].value.kwargs:
					kwargs["avatar"] = Ren.values[org_kwargs.how].value.kwargs.avatar
				
				if "what" in kwargs:
					kwargs.what = how.parse_what(kwargs.what)
	
	if "how" in kwargs:
		kwargs.how = Ren.text_passer(kwargs.how)
	
	if "what" in kwargs:
		kwargs.what = Ren.text_passer(kwargs.what)
	
	.enter(false)

func on_exit(new_kwargs = {}):
	.on_exit(new_kwargs)
	
	if not (self in Ren.history):
		Ren.history.append(self)