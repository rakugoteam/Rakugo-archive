
extends VButtonArray

# This is Ren'GD API
# version: 0.0.1

var _values
onready var _say_screen = get_node("/root/Window/Say")
onready var _ren = get_node("/root/ren_basic")

func _ready():
	connect("button_selected", self, "_on_choice")
	_test()

func _test():
	choice({
				"say 1": ["$ _say_screen.say('test', '1')"],
				"say 2": ['$ _say_screen.say("test","2")']
				})

func choice(items):
	_say_screen.hide()
	_values = items.values()
	clear()

	for k in items.keys():
		add_button(k)

	show()

func _on_choice(id):
	var s
	for l in _values[id]:
		s = _ren.line_passer(l)[1]

	_say_screen.say(s[0], s[1])

	hide()
