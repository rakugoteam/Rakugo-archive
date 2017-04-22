## This is Ren'GD API ##
## Ren'GD is Ren'Py for Godot ##
## version: 0.6 ##
## License MIT ##


extends Node


onready var label_manager = get_node("LabelManager")


func start_ren():
    ## This must be at end of code using ren api
	## this start ren "magic" ;)
    use_statement(0)


func label(label_name, scene_path, node_path = null, func_name = null):
    ## this declare new label
    ## that make ren see label and can jump to it
    label_manager.label(label_name, scene_path, node_path, func_name)


func jump(label_name, args = []):
    ## go to other declared label
    label_manager.jump(label_name, args)


func godot_line(fun, args = []):
    ## append g statement
    ## use it to execute godot func in rengd
    var s = {"type":"g",
            "fun":fun
            }
    
    return s


func append_godot_line(fun, args = []):
    ## return g statement
    ## use it to execute godot func in rengd
    var s = append_godot_line(fun, args)
    statements.append(s)



