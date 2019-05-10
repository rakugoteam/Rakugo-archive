## This is example of script using Rakugo Framework ##

extends Node

func _ready():
	if Rakugo.current_root_node != self:
		Rakugo.current_root_node = self
	
	Rakugo.emoji_size = 36 # possible sizes are: 16, 36, 72
	
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
#				"kind": "phone_left",
				"time" : 0, # time bettwen letters
				"what": "Test 1 {:grinning:}"
				})
	
		1:
			Rakugo.say({
				"who": "ch2",
#				"kind": "phone_right",
				"time" : 0, # time bettwen letters
				"what": "Test 2 {:thumbsup:}"
				})
		
		2:
			Rakugo.say({
				"who": "ch1",
#				"kind": "phone_left",
				"time" : 0, # time bettwen letters
				"what": "Test 3"
				})
	
		3:
			Rakugo.say({
				"who": "ch2",
#				"kind": "phone_right",
				"time" : 0, # time bettwen letters
				"what": "Test 4"
				})
	
