## This is Ren'GD API ##

## version: 0.7 ##
## License MIT ##

extends Object

var statements_before_menu = []
var statements_after_menu = []


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


func array_slice(array, from = 0, to = 0):
	if from > to or from < 0 or to > array.size():
		return array
	
	var _array = array

	for i in range(0, from):
		_array.remove(i)
	
	_array.resize(to - from)

	return _array


func before_menu(num, statements, current_statements):
	## must be on begin of menu custom func
	statements_before_menu = array_slice(statements, 0, num+1)
	statements_after_menu = array_slice(statements, num+1, statements.size()+1)
	current_statements = statements_before_menu


func after_menu(current_statements):
	## must be on end of menu custom func
	current_statements += statements_after_menu

