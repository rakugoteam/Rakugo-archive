extends Timer


func _ready():
	self.wait_time = Settings.get("rakugo/default/delays/skip_delay")


func on_loop():
	if can_skip():
		Rakugo.story_step()
	elif not Rakugo._skip_after_choices:
		stop()


func can_skip() -> bool:
	var output = Rakugo.skipping
	output = output and (not Rakugo.History.step_has_unseen or Rakugo._skip_all_text)
	output = output and (not Rakugo.stepping_blocked) #A bit redundant
	return output
