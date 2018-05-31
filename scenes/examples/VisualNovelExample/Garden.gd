extends Node2D

func _ready():
	Ren.connect("story_step", self, "story")
	Ren.story_step()

func story(dialog_name):
	if dialog_name != "garden":
		return
	
	match Ren.story_state:
		"start":
			Ren.show("alice", ["happy"])
			Ren.say({"who":"alice", "what":"Welcome in my Garden [player_name].", "kind":"left"})
	
	


