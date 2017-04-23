## This is Ren'GD API ##
## Ren'GD is Ren'Py for Godot ##
## version: 0.6 ##
## License MIT ##

extends "ren_input.gd"

onready var choice_screen = get_node("Choice")

func array_slice(array, from = 0, to = 0):
 	if from > to or from < 0 or to > array.size():
 		return array
 	
 	var _array = array
 
 	for i in range(0, from):
 		_array.remove(i)
     
 	_array.resize(to - from)
 
 	return _array
    

func before_menu():
    ## must be on begin of menu custom func
    choice_screen.before_menu()


func after_menu():
	## must be on end of menu custom func
    choice_screen.after_menu()


func menu_func_statement(choices, title, node, func_name):
	## return custom menu statement
	## made to use menu statement easy to use with gdscript
    return choice_screen.statement_func(choices, title, node, func_name)


func append_menu_func(choices, title, node, func_name):
    ## append menu_func statement
    var s = menu_func_statement(choices, title, node, func_name)
    statements.append(s)


func menu_func(statement):
    ## "run" menu_func statement
    choice_screen.use_with_func(statement)


func menu_statement(choices, title = ""):
    ## return menu statement
    return choice_screen.statement(choices, title)


func append_menu(choices, title = ""):
    ## append menu statement
    var s = menu_statement(choices, title)
    statements.append(s)


func menu(statement):
    ## "run" menu statement
    choice_screen.use(statement)