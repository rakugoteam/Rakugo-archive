## This is Ren'GD API ##
## Ren'GD is Ren'Py for Godot ##
## version: 0.06 ##
## License MIT ##

extends VBoxContainer

var how
var what

onready var ren = get_node("/root/Window")
onready var dialog_screen = get_node("Dialog")
onready var namebox_screen = get_node("NameBox/Label")


func statement(how, what):
    ## return say statement
    var s = {"type":"say",
                "args":{
                        "how":how,
                        "what":what
                        }
            }
    
    return s


func append(how, what):
    ## append say statement 
    var s = say(how, what)
    ren.statements.append(s)


func use(statement):
    ## "run" say statement
    var args = statement.args
    how = args.how
    what = args.what

    if how in ren.keywords:
        if ren.keywords[how].type == "Character":
            how = ren.keywords[how].value
            
            var nhow = ""
            
            if how.name != "" or null:
                nhow = "{color=" + how.color + "}"
                nhow += how.name
                nhow += "{/color}"
            
            what = how.what_prefix + what + how.what_suffix
            how = nhow

    how = ren.say_passer(how)
    what = ren.say_passer(what)

    namebox_screen.set_bbcode(how)
    dialog_screen.set_bbcode(what)
    dialog_screen.show()