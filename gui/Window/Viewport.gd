extends Viewport

func _ready():
	var s = get_tree().current_scene
	s.connect("ready", self, "attach")

func attach():
	var s = get_tree().current_scene
	var p = s.get_parent()
	p.call_deferred("remove_child", s)
	call_deferred("add_child", s)

