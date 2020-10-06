extends Timer


func run():
	Rakugo.skip_auto = true
	start()


func on_loop():
	if Rakugo.skip_auto and Rakugo.can_auto():
		Rakugo.story_step()
	else:
		Rakugo.skip_auto = false
		stop()
