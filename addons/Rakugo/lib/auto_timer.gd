extends Timer

#TODO add the necessary to set the timer once settings are reworked
func on_loop():
	if Rakugo.auto_stepping:
		Rakugo.story_step()
	else:
		stop()
