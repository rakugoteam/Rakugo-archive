extends Popup

export(float, 0, 1, 0.1) var fade_time = 0.3
export(float, 0.5, 3, 0.1) var base_duration = 2
export(float, 0, 0.5, 0.05) var duration_factor_per_word = 0.1

func _ready():
	Rakugo.connect("notify", self, "_on_notify")


func _on_notify(text:String, parameters:Dictionary):
	$Label.text = text
	fade_in()

func fade_in():
	var splits = $Label.text.split(" ", false)
	$Tween.remove_all()
	$Tween.interpolate_property(self, "modulate", Color(1,1,1,0), Color(1,1,1,1), fade_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_deferred_callback(self, fade_time + base_duration * (1 + duration_factor_per_word * splits.size()), "fade_out")
	$Tween.start()
	popup()


func fade_out():
	$Tween.remove_all()
	$Tween.interpolate_property(self, "modulate", Color(1,1,1,1), Color(1,1,1,0), fade_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_deferred_callback(self, fade_time, "hide")
	$Tween.start()


