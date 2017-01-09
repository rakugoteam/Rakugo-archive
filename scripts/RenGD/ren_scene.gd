## This is ren_script to gd_script compilator ##
## Ren'GD is Ren'Py for Godot ##
## version: 0.04 ##
## License MIT ##
## Copyright (c) 2016 Jeremi Biernacki ##
## This part is hold on and don't work yet ##

extends Node

# var _nodes = []
# var _args = []


func quotes():
    return "\"".c_escape()

func apost():
    return "\'".c_escape()

func lend():
    return "\n".c_escape()

func tab():
    return "\t".c_escape()

func _ready():
    _input_screen.connect("text_entered", self, "_on_input")

    print("test line passer:")
    var line_code = line_passer("$ self.get_name()")
    print(line_code)

    var line_say_a = line_passer("\"developer\" \"This is just test\"")
    print(line_say_a)

    var line_say_b = line_passer("\'developer\' \'This is just test\'")
    print(line_say_b)