## This is Ren'GD API ##
## Ren'GD is Ren'Py for Godot ##
## version: 0.6 ##
## License MIT ##

extends "ren_say.gd"

onready var input_screen = get_node(adv_path + "/Input")

func input_statement(ivar, what, temp = ""):
    ## return input statement
    return input_screen.statement(ivar, what, temp)


func append_input(ivar, what, temp = ""):
    ## append input statement
    var s = input_statement(ivar, what, temp)
    statements.append(s)


func input(statement):
   ## "run" input statement
   input_screen.use(statement)