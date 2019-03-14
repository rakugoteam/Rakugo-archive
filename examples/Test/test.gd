## This is example of script using Rakugo Framework ##

extends Node

func _ready():
	if Rakugo.current_root_node != self:
		Rakugo.current_root_node = self
	
	Rakugo.begin("Test/PhoneTest", name, "example")
	Rakugo.add_dialog(self, "example")

func example(node_name, dialog_name):
	if node_name != name:
		return

	if dialog_name != "example":
		return
	
	match Rakugo.story_state:
		0:
			Rakugo.say({
				"who": "ch1",
				"kind": "phone_left",
				"what": "Test 1"
				})
	
		1:
			Rakugo.say({
				"who": "ch2",
				"kind": "phone_right",
				"what": "Test 2"
				})
		
		2:
			Rakugo.say({
				"who": "ch1",
				"kind": "phone_left",
				"what": "Test 3"
				})
	
		3:
			Rakugo.say({
				"who": "ch2",
				"kind": "phone_right",
				"what": "Test 4"
				})
	
