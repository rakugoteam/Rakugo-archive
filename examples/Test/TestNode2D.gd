extends RakugoNode2D

## This is small extra script that shows
## how to make node save/load

var is_show : RakugoVar

func _ready():
	is_show = Rakugo.define("test_node2d_is_show", visible)
	connect("visibility_changed", self, "_on_vis_changed")
	is_show.connect("value_changed", self, "on_value_changed")

func _on_vis_changed():
	is_show.v = visible

func on_value_changed(vname:String, new_value) -> void:
	if vname != is_show.name:
		return

	visible = is_show.v