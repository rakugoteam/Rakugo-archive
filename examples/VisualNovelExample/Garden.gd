extends Node2D

func _ready():
	if Ren.current_root_node != self:
		Ren.current_root_node = self
	
	Ren.add_dialog(self, "garden")

func garden(dialog_name):
	if dialog_name != "garden":
		return
		
	Ren.show("alice", ["happy"])
	Ren.say({
		"who":"alice",
		"what":"Welcome in my Garden [player_name].",
		"kind":"left"
	})
	
	


