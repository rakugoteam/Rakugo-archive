## This is Ren'GD API ##

## version: 0.7 ##
## License MIT ##

extends Object

func statement(how, what):
	## return say statement
	var s = {"type":"say",
				"args":{
						"how":how,
						"what":what
						}
			}
	
	return s


func use(statement, vars):
	## "run" say statement
	var args = statement.args
	var how = args.how
	var what = args.what

	if how in vars:
		if vars[how].type == "Character":
			how = vars[how].value
			
			var nhow = ""
			
			if how.name != "" or null:
				nhow = "{color=" + how.color + "}"
				nhow += how.name
				nhow += "{/color}"
			
			what = how.what_prefix + what + how.what_suffix
			how = nhow

	return [how, what]