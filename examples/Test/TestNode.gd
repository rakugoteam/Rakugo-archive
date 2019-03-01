extends Sprite

func _ready():
	Rakugo.node_link(self, name)

func test_func(some_text):
	print(some_text)
	show()

