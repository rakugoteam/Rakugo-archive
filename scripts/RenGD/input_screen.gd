## This is Ren'GD API ##
## Ren'GD is Ren'Py for Godot ##
## version: 0.6 ##
## License MIT ##

extends LineEdit

var temp
var what
var ivar

onready var ren = get_node("/root/Window")
onready var namebox_screen = get_node("../NameBox/Label")
onready var dialog_screen = get_node("../Dialog")

func _ready():
    connect("text_entered", self, "_on_input")


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


func append_input(ivar, what, temp = ""):
    ## append input statement
    var s = input(ivar, what, temp)
    ren.statements.append(s)


func use(statement):
    ## "run" input statement
    var args = statement.args
    ivar = args.ivar
    what = args.what
    temp = args.temp

    temp = ren.text_passer(temp)
    what = ren.text_passer(what)

    set_text(temp)
    namebox_screen.set_bbcode(what)

    dialog_screen.hide()
    show()
    grab_focus()
    ren.can_roll = false


func _on_input(s):
    ren.keywords[ivar] = {"type":"text", "value":s}
    ren.can_roll = true
    hide()
    ren.next_statement()