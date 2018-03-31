## This is example of script using Ren Framework ##
## version: 0.5.0 ##
## License MIT ##

extends Node

func _test_func_call():
	print("call_func statement works!")

func _ready():
	Ren.dialog_node = self
	Ren.define("player_name")
	Ren.define("test_list", [1,3,7])
	Ren.say({"what":"test list 2 list elment is [test_list[2]]"})
	Ren.call_func(self, "_test_func_call")
	Ren.show("rench", [], {"at":["center"]})
	
	Ren.input({
				"who": 
					"rench",
				"what":
					"Hi! I'm Ren. What is your name?",
				"input_value":
						"player_name",
				"value":
					"Developer"
				})
	
	Ren.say({
				"who": 
					"rench",
				"what":
					"Welcome [player_name] in Ren Framework Version [version]",
				"speed":
					0.1
				})
	Ren.hide("rench")
	Ren.say({
			"who": 
				"rench",
			"what":
				"extra stamement to check skipping/auto",
			})

	var menu01 = Ren.menu({
				"who":
					"rench",
				"what":
					"What want to do?"
				})

	var choice_vn = Ren.choice({"what": "Play Visual Novel example"}, menu01)
	Ren.say({
				"who":
					"rench",
				"what":
					"Visual Novel example is not ready yet"
			}, choice_vn)
	
				
	var choice_adv = Ren.choice({"what": "Play Click'n'Point Adventure example"}, menu01)
	Ren.say({
			"who":
				"rench",
			"what":
				"Click'n'Point Adventure example is not ready yet"
			}, choice_adv)
	

	var choice_rpg = Ren.choice({"what": "Play RPG example"}, menu01)
	Ren.say({
				"who":
					"rench",
				"what":
					"RPG example is not ready yet"
			}, choice_rpg)
	

	var choice_aq = Ren.choice({"what": "Ask some questions about Ren"}, menu01)
	Ren.say({
				"who":
					"rench",
				"what":
					"Docs are not ready yet"
			}, choice_aq)
	
	Ren.notifiy("You make your first choice!",3)
	
	Ren.say({
			"who": 
				"rench",
			"what":
				"End of Example",
			})

