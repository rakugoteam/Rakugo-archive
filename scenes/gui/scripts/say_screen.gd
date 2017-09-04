## This is Ren'GD API ##

## version: 0.7 ##
## License MIT ##

extends VBoxContainer

onready var ren				= get_node("/root/Window")
onready var dialog_screen	= get_node("Dialog")
onready var namebox_screen	= get_node("NameBox/Label")
onready var input_screen	= get_node("Input")

func _ready():
	ren.connect("say", self, "on_say")
	ren.connect("ren_input", self, "on_input")
	input_screen.connect("text_entered", self, "on_text_entered")


func on_say(how, what, kind):
	namebox_screen.set_bbcode(how)
	dialog_screen.set_bbcode(what)
	dialog_screen.show()


func on_input(what, temp):
	input_screen.set_placeholder(temp)
	namebox_screen.set_bbcode(what)
	dialog_screen.hide()
	input_screen.show()
	input_screen.grab_focus()


func on_text_entered(text):
	if text == "":
		text = input_screen.get_placeholder()
	
	ren.set_ren_input_var(text)

	input_screen.hide()
