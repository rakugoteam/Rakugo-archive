## This is Ren'GD API ##

## version: 0.7 ##
## License MIT ##

extends Object

func statement(choices, question, node = null, func_name = ""):
	## return menu statement
	var s = {
		"type": "menu",
		"args":
			{
			"question": question,
			"choices": choices,
			"node": node,
			"func_name": func_name
			}
	}

	return s


func use(statement):
	## "run" custom menu statement
	return statement.args

