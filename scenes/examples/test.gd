## This is example of script using Ren Framework ##

extends Node

func _test_func_call():
	print("call_func statement works!")

func _ready():
	## this must be at start of dialog func
	Ren.dialog_node = self
	
	## example of using Ren.value in text
	Ren.define("test_list", [1,3,7])
	Ren.say({"what":"test list 2 list element is [test_list[2]]"})
	
	## example of calling godot func as statement
	Ren.call_func(self, "_test_func_call")
	
	## example of updateing some Ren.value
	Ren.define("test_var", 1)
	Ren.say({"what":"now test_var = [test_var]"})
	Ren.say({"what":"add 1 to test_var"})
	Ren.gd("test_var += 1")
	Ren.say({"what":"and now test_var = [test_var]"})

	## showing Ren's node or character with id 'rench' at center
	Ren.show("rench", [], {"at":["center"]})

	## example getting user input to Ren.value
	Ren.define("player_name")
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
	
	## example of showing text slow
	Ren.say({
		"who": 
			"rench",
		"what":
			"Welcome [player_name] in Ren Framework Version [version]",
		"speed":
			0.1
		})

	## hidding Ren's node or character with id 'rench' 
	Ren.hide("rench")
	Ren.say({
		"who": 
			"rench",
		"what":
			"extra stamement to check skipping/auto",
		})
	
	# example of creating menu
	var menu01 = Ren.menu({
		"who":
			"rench",
		"what":
			"What want to do?"
		})
	
	## exmaple of adding choice to menu
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

