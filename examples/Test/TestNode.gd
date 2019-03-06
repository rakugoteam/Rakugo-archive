extends Sprite

## This is small extra script that shows
## how to make node save/load
## we also call "test_func" for dialog

var is_show : RakugoVar

func _ready():
	Rakugo.node_link(self, name)
	Rakugo.define("test_node_is_show", visible)
	connect("visibility_changed", self, "_on_vis_changed")
	Rakugo.connect("loaded", self, "_on_loaded")

func _on_vis_changed():
	Rakugo.define("test_node_is_show", visible)

func _on_loaded(version):
	visible = Rakugo.get_value("test_node_is_show")

func test_func(some_text):
	print(some_text)
	show()

