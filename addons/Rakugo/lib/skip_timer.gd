extends Timer

#TODO add the necessary to set the timer once settings are reworked
func on_loop():
	if can_skip():
		Rakugo.story_step()
	elif not Rakugo._skip_after_choices:
		stop()


func can_skip() -> bool:
	var output = Rakugo.skipping
	output = output and (not Rakugo.History.step_has_unseen or Rakugo._skip_all_text)
	output = output and (not Rakugo.stepping_blocked) #A bit redundant
	print("Can skip ? ",output, " ", (not Rakugo.History.step_has_unseen))
	return output
