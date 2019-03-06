extends Node2D

func _ready():
	if Rakugo.current_root_node != self:
		Rakugo.current_root_node = self
	
	Rakugo.add_dialog(self, "garden")

func garden(node_name, dialog_name):
	if node_name != name:
		return
		
	if dialog_name != "garden":
		return
		
	Rakugo.show("alice", ["happy"])
	Rakugo.say({
		"who":"alice",
		"what":"Welcome in my Garden [player_name].",
		"kind":"left"
	})
	
	


