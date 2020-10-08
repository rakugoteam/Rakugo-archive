extends Timer

#TODO add the necessary to set the timer once settings are reworked
func on_loop():
	if can_skip():
		Rakugo.story_step()
	else:
		stop()


func can_skip() -> bool:
	var seen = Rakugo.is_current_statement_in_global_history()
	return Rakugo.skipping and (seen or Rakugo._skip_all_text) and (not Rakugo.stepping_blocked or Rakugo._skip_after_choices)
