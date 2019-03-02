extends RakugoNode2D

## This is small extra script that shows
## how to make node save/load

var is_show : RakugoVar

func _ready():
	is_show = Rakugo.define("test_node_is_show", visible)
	connect("visibility_changed", self, "_on_vis_changed")

func _on_vis_changed():
	is_show.v = visible;

func _on_load(version):
	visible = is_show.v