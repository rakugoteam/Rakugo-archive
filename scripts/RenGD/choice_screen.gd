
extends VButtonArray

# This is Ren'GD API
# version: 0.0.1
onready var _ren = get_node("/root/Window/Say")

func _ready():
	_test()

func _test():
	choice({
				"say 1": "$ _ren.say('test', '1')",
				"say 2": "$ _ren.say('test', '2')"
				})

func choice(items):
	disconnect("button_selected", self, "_on_choice")
	clear()

	for k in items.keys():
		add_button(k)

	connect("button_selected", self, "_on_choice", [items])
	show()


func _on_choice(id, items):
	print(items)
	hide()
	
