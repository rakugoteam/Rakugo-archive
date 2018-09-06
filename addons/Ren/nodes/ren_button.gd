extends "ren_button.gd"

var quest

func setup(quest_id):
	quest = Ren.get_quest(quest_id)
	no_title_changed(quest.title)
	on_optional_changed(quest.optional)
	on_state_changed(quest.state)

	quest.connect("title_changed", self, "on_title_changed")
	quest.connect("optional_changed", self, "on_optional_changed")
	quest.connect("state_changed", self, "on_state_changed")

func on_title_changed(new_title):
	node_to_change.text = quest.title

func on_optional_changed(opt):
	if opt:
		$AnimatedSprite.animation = "opt"
	else:
		$AnimatedSprite.animation = "default"

func on_state_changed(new_state):
	$AnimatedSprite.frame = new_state - 1