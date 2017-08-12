## This is Ren'GD API ##

## version: 0.7 ##
## License MIT ##

extends LineEdit


onready var ren = get_node("/root/Window")
onready var namebox_screen = get_node("../NameBox/Label")
onready var dialog_screen = get_node("../Dialog")

func _ready():
	ren.connect("ren_input", self, "on_input")
	connect("text_entered", self, "on_text_entered")


func on_input(what, temp):
	set_text(temp)
	namebox_screen.set_bbcode(what)

	dialog_screen.hide()
	show()
	grab_focus()


func on_text_entered(text):
	ren.set_ren_input_var(text)
	hide()
