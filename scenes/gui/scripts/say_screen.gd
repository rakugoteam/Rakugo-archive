## This is Ren'GD API ##

## version: 0.7 ##
## License MIT ##

extends VBoxContainer

onready var ren = get_node("/root/Window")
onready var dialog_screen = get_node("Dialog")
onready var namebox_screen = get_node("NameBox/Label")

func _ready():
	ren.connect("say", self, "on_say")

func on_say(how, what, kind):
	namebox_screen.set_bbcode(how)
	dialog_screen.set_bbcode(what)
	dialog_screen.show()