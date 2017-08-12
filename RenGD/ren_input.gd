## This is Ren'GD API ##

## version: 0.7 ##
## License MIT ##

extends Object


func statement(ivar, what, temp = ""):
	## add input statement

	var s = {"type":"input",
				"args":{
						"ivar":ivar,
						"what":what,
						"temp":temp
						}
			}
	
	return s


func use(statement):
	## "run" input statement
	var args = statement.args
	return args
