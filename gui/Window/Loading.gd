extends Control


func _ready():
	hide()
	Rakugo.SceneLoader.connect('load_scene', self, 'on_load_scene')
	Rakugo.SceneLoader.connect('scene_loaded', self, 'on_scene_loaded')
	
func on_load_scene(_ril):
	show()

func on_scene_loaded():
	hide()
