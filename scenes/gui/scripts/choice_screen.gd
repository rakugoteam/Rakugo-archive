## This is Ren'GD API ##

## version: 0.1.0 ##
## License MIT ##

extends VBoxContainer

onready var ren = get_node("/root/Window")
onready var chbutton = preload("res://scenes/gui/ChoiceButton.tscn")

func _ready():
	ren.connect("menu", self, "on_menu")
	ren.connect("after_menu", self, "hide")


func on_menu(choices, question, node, func_name):
	## "run" menu statement
	ren.can_roll = false
	
	for ch in get_children():
		ch.free()

	if question != "":
		var s = ren.say_statement("", question)
		ren.say(s)
	
	else:
		ren.say_screen.hide()
	
	for key in choices:
		var b = chbutton.instance()
		
		add_child(b)

		var k = "{center}" + key + "{/center}"
		k = ren.text_passer(k)

		var tr = b.get_child(0)
		tr.set_bbcode(k)

		b.connect("pressed", node, func_name, [key])
	
	show()






