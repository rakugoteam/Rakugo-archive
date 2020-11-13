extends Timer


func _ready():
	self.wait_time = float(Settings.get("rakugo/default/delays/auto_mode_delay"))

func on_loop():
	if Rakugo.auto_stepping:
		Rakugo.story_step()
	else:
		stop()
