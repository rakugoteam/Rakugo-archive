extends Sprite

func _ready():
	Ren.node_link(self, name)

func test_func(some_text):
	print(some_text)
	show()

