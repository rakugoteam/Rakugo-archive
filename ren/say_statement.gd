## This is RenAPI ##

## version: 0.1.0 ##
## License MIT ##
## Say class statement ##

extends "res://ren/statement.gd"

func _init():
	type = "say"
	kws = ["how", "what"]

func use():
	# if "how" in kwargs:
	# 	if kwargs.how in ren.values:
	# 		if kwargs.how.type == "Character":
	# 			var how = kwargs.how.value
	# 			kwargs.how = how.parse_character(kwargs.values)
	# 			kwargs.what = how.parse_what(kwargs.what)
		
	# if "what" in kwargs:
	# 	kwargs.what = text_passer(kwargs.what, kwargs.values)
	
	.use()
	