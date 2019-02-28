extends Node2D

func _ready():
	if Rakugo.currakugot_root_node != self:
		Rakugo.currakugot_root_node = self
	
	Rakugo.add_dialog(self, "garden")

func garden(dialog_name):
	if dialog_name != "garden":
		return
		
	Rakugo.show("alice", ["happy"])
	Rakugo.say({
		"who":"alice",
		"what":"Welcome in my Garden [player_name].",
		"kind":"left"
	})
	
	


