## This is Ren'GD example say script##

## version: 0.7 ##
## License MIT ##

extends "res://RenGD/ren_short.gd"

var tscn_path

func _ready():
	tscn_path = get_parent().tscn_path
	dialog("say", tscn_path, get_path(), 'dialog_say')
	dialog("input", tscn_path, get_path(), 'dialog_input')


func dialog_say():
	pass


func dialog_input():
	say("jer", "Now we test your math skills.")
	define("math_test", 0)
	ren_input("math_test", "13 + 4?", "0")
	g("print(math_test)")
	ren_if("math_test == 17")
	say("jer", "Good answer!!!")
	ren_else()
	say("jer", "Bad answer.")
	ren_end()
