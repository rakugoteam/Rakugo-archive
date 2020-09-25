extends Control


func _ready():
	hide()
	Rakugo.connect('load_scene', self, 'on_load_scene')
	Rakugo.connect('scene_loaded', self, 'on_scene_loaded')
	
func on_load_scene():
	show()

func on_scene_loaded():
	hide()
