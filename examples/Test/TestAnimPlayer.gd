extends RakugoAnimPlayer

## This is small extra script that shows
## how to make node save/load

var anim_name : String
var anim_is_playing : bool

func _ready():
	Rakugo.define("test_anim_name", "")
	Rakugo.define("test_anim_is_playing", false)
	connect("animation_changed", self, "_on_anim_name_changed")
	connect("animation_finished", self, "_on_anim_finished")
	connect("animation_started", self, "_on_anim_started")
	Rakugo.connect("loaded", self, "_on_loaded")

func _on_anim_name_changed(old_name, new_name):
	Rakugo.define("test_anim_name", new_name)
	
func _on_anim_finished(a_name):
	Rakugo.define("test_anim_name", a_name)
	Rakugo.define("test_anim_is_playing", false)
	
func _on_anim_started(a_name):
	Rakugo.define("test_anim_name", a_name)
	Rakugo.define("test_anim_is_playing", true)

func _on_loaded(version):
	anim_name = Rakugo.get_value("test_anim_name")
	anim_is_playing = Rakugo.get_value("test_anim_is_playing")
	if anim_is_playing:
		play(anim_name) 

	elif is_playing():
		stop(false)
	
