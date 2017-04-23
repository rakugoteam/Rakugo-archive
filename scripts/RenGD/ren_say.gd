## This is Ren'GD API ##
## Ren'GD is Ren'Py for Godot ##
## version: 0.6 ##
## License MIT ##

extends "ren_text.gd"

var vbc = "VBoxContainer"

## paths to nodes to use with special kinds of charcters
var adv_path = "Adv/" + vbc
var cen_path = "Center/" + vbc
var fs_path = "FullScreen" + vbc

onready var say_screen = get_node(adv_path)
onready var nvl_scroll = get_node("Nvl")
onready var nvl_screen = get_node("Nvl/" + vbc)

onready var say_scene = preload("res://scenes/gui/Say.tscn")

func say_statement(how, what):
    ## return input statement
    return say_screen.statement(how, what)


func append_say(how, what):
    ## append say statement 
    var s = say_statement(how, what)
    statements.append(s)


func say(statement):
    ## "run" say statement
    var how = statement.args.how

    # if how.kind == "adv":
    say_screen = get_node(adv_path)

    if how in keywords:
        if keywords[how].type == "Character":
            var kind = keywords[how].value.kind
            
            if kind == "center":
                say_screen.hide()
                get_node(fs_path).hide()
                say_screen = get_node(cen_path)
            
            elif kind == "fullscreen":
                say_screen.hide()
                get_node(cen_path).hide()
                say_screen = get_node(fs_path)
            
            elif kind == "nvl":
                say_screen.hide()
                get_node(fs_path).hide()
                get_node(cen_path).hide()
                say_screen = say_scene.instance()
                nvl_screen.add_child(say_screen)
                var y = say_screen.get_pos().y
                nvl_scroll.set_v_scroll(y)
                nvl_scroll.show()
    
            if kind != "nvl":
                var ipath = str(say_screen.get_path()) + "/Input"
                input_screen = get_node(ipath)

    say_screen.use(statement)