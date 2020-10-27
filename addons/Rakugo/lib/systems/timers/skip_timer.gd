extends Timer

var skip_after_choices = false

func _ready():
	self.wait_time = Settings.get("rakugo/default/delays/skip_delay")
	#self.skip_after_choices = Settings.get("rakugo/skip_after_choice")


func on_loop():
	if can_skip():
		Rakugo.story_step()
	#TODO implement skipping stops


func can_skip() -> bool:
	var output = Rakugo.skipping
	output = output and (not Rakugo.History.step_has_unseen)#TODO add back skip unseen
	output = output and (not Rakugo.StepBlocker.is_blocking())
	return output
