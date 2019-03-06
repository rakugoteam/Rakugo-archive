extends RakugoAnimPlayer

## This is small extra script that shows
## how to make node save/load

var anim_name : RakugoVar
var anim_is_playing : RakugoVar

func _ready():
	anim_name = Rakugo.define("test_anim_name", "")
	anim_is_playing = Rakugo.define("test_anim_is_playing", false)
	connect("animation_changed", self, "_on_anim_name_changed")
	connect("animation_finished", self, "_on_anim_finished")
	connect("animation_started", self, "_on_anim_started")
	Rakugo.connect("loaded", self, "_on_loaded")

func _on_anim_name_changed(old_name, new_name):
	print(new_name)
	anim_name.value = new_name
	
func _on_anim_finished(a_name):
	anim_is_playing.v = false
	## is the same as:
	## anim_is_playing.value = false;
	
func _on_anim_started(a_name):
	anim_name.value = a_name
	anim_is_playing.v = true

func _on_loaded(version):
	if anim_is_playing.v:
		play(anim_name.v)

	elif is_playing():
		stop(false)
	
