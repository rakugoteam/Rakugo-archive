## This is Ren'GD API ##

## version: 0.7 ##
## License MIT ##

extends Node

onready var ren = get_node("/root/Window")


func statmente(expression):
	## return g statement
	var s = {"type":"g", "arg":expression}
	return s


func append(expression):
	## append g statement
	var s = statement(expression)
	ren.statement.append(s)


func use(statement):
	## "run" g statement
	var expression = statement.arg

	# for key_name in ren.keywords:
	# 	if expression.find(key_name) == -1:
	# 		continue # no keyword in this string
		


