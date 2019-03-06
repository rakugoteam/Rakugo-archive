extends RakugoNode2D

## This is small extra script that shows
## how to make node save/load

var is_show : RakugoVar

func _ready():
	Rakugo.define("test_node_is_show", visible)
	connect("visibility_changed", self, "_on_vis_changed")
	Rakugo.connect("loaded", self, "_on_loaded")

func _on_vis_changed():
	Rakugo.define("test_node_is_show", visible)

func _on_loaded(version):
	Rakugo.define("test_node_is_show", visible)