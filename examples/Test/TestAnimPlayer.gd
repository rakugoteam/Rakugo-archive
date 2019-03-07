extends RakugoAnimPlayer

## This is small extra script that shows
## how to make node save/load

var anim_name : RakugoVar
var anim_is_playing : RakugoVar

func _ready():
	anim_name = Rakugo.define("test_anim_name", "")
	anim_is_playing = Rakugo.define("test_anim_is_playing", false)
	connect("animation_changed", self, "_on_anim_changed")
	connect("animation_finished", self, "_on_anim_finished")
	connect("animation_started", self, "_on_anim_started")
	anim_name.connect("value_changed", self, "_on_anim_name_changed")
	anim_is_playing.connect("value_changed", self, "_on_anim_is_playing_changed")

func _on_anim_changed(old_name, new_name):
	anim_is_playing.v = new_name
	
func _on_anim_finished(a_name):
	anim_is_playing.v = false
	
func _on_anim_started(a_name):
	anim_is_playing.v = true

func _on_anim_name_changed(vname:String, new_value:String):
	if vname != anim_name.name:
		return

	current_animation = anim_name.v

func _on_anim_is_playing_changed(vname:String, new_value:float):
	if vname != anim_is_playing.name:
		return
		
	if is_playing() == anim_is_playing.v:
		return
		
	if anim_name.v == "":
		prints("some gone wrong anim_name is: ''")
		return

	if anim_is_playing.v:
		play(anim_name.v) 

	elif is_playing():
		stop(false)
	
