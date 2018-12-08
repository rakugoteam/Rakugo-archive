extends Sprite

func _ready():
	# Ren.define(name, self)
	Ren.node_link(self, name)

func test_func(some_text):
	print(some_text)
	show()

