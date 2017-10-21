## This is RenAPI ##

## version: 0.1.0 ##
## License MIT ##
## Say class statement ##

extends "statement.gd"

var org_kwargs

func _init():
	type = "say"
	kws = ["how", "what"]

func use():
	org_kwargs = kwargs
	if "how" in kwargs:
		if kwargs.how in ren.values:
			if ren.values[kwargs.how].type == "Character":
				var how = ren.values[kwargs.how].value
				kwargs.how = how.parse_character(ren.values)
				kwargs.what = how.parse_what(kwargs.what)
		
	if "what" in kwargs:
		kwargs.what = text_passer(kwargs.what)
	
	.use()
	kwargs = org_kwargs
	