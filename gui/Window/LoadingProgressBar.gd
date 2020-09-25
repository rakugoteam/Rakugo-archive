extends ProgressBar

var ril:ResourceInteractiveLoader = null


func _ready():
	Rakugo.connect('load_scene', self, 'on_load_scene')
	Rakugo.connect('loading_scene', self, 'on_loading_scene')
	
func on_load_scene(_ril):
	self.ril = _ril
	self.set_max(ril.get_stage_count())

func on_loading_scene():
	self.set_value(ril.get_stage());
