extends Node2D

func _ready():
	Ren.story_step()

	if "garden" == yield(Ren, "story_step"):
		Ren.show("alice", ["happy"])
		Ren.say({
			"who":"alice",
			"what":"Welcome in my Garden [player_name].",
			"kind":"left"
		})
	
	


