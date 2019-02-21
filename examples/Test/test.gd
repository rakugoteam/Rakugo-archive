## This is example of script using Ren Framework ##

extends Node

var test_var
var test_quest
var test_subquest

func _ready():
	Ren.jump("Test/Test", "example", 0, false)

	if Ren.current_node != self:
		Ren.current_node = self
	
	test_var = Ren.define("test_var", 1)
	test_quest = Ren.quest("test_quest")
	test_quest.title = "Test Quest"
	test_quest.description = "Your first epic quest."
	
	test_subquest = Ren.subquest("test_subquest")
	test_subquest.title = "Test Subquest"
	test_subquest.description = "Your first epic subquest."
	test_subquest.optional = true
	test_quest.add_subquest(test_subquest)

	var dialog_name = "example"
	var id = 0
	yield(Ren, "story_step")
	if Ren.current_dialog_name == dialog_name:
		if id == Ren.story_state:
			id += 1
			Ren.call_node("TestNode", "test_func", ["test of call node"])
			Ren.say({"what": "Test of call in func form node using call_node."})
	
	yield(Ren, "story_step")
	if Ren.current_dialog_name == dialog_name:	
		# test of quest system part1
		if id == Ren.story_state:
			id += 1
			test_quest.start()
			Ren.say({"what": "For test quest system now will you start test quest."})
		
	yield(Ren, "story_step")
	if Ren.current_dialog_name == dialog_name:	
		if id == Ren.story_state:
			id += 1
			test_quest.finish()
			Ren.say({"what": "And now test quest is done."})
	
	yield(Ren, "story_step")
	if Ren.current_dialog_name == dialog_name:	
		# "test play_anim":
		if id == Ren.story_state:
			id += 1
			Ren.play_anim("TestAnimPlayer", "test")
			Ren.say({"who":"test", "what":"test of playing simple anim"})
	
	yield(Ren, "story_step")
	if Ren.current_dialog_name == dialog_name:	
		# "test stop_anim 1":
		if id == Ren.story_state:
			id += 1
			Ren.stop_anim("TestAnimPlayer", true)
			Ren.play_anim("TestAnimPlayer", "test_loop")
			Ren.say({
				"who":"test",
				"what":"test of stoping loop anim."+
				"{/nl}Click to go next step and stop anim"
			})
	
	yield(Ren, "story_step")
	if Ren.current_dialog_name == dialog_name:	
		# "test stop_anim 2":
		if id == Ren.story_state:
			id += 1
			Ren.stop_anim("TestAnimPlayer", true)
			Ren.say({
				"who":"test",
				"what":"test anim stopped"
			})
		
	yield(Ren, "story_step")
	if Ren.current_dialog_name == dialog_name:	
		# "test sfx":
		if id == Ren.story_state:
			id += 1
			Ren.play_audio("SFXPlayer")
			Ren.say({"who":"test", "what":"now you hear sfx."})

	yield(Ren, "story_step")
	if Ren.current_dialog_name == dialog_name:		
		# "test bgm 1":
		if id == Ren.story_state:
			id += 1
			Ren.play_audio("BGMPlayer")
			Ren.say({
				"who":"test", "what":"now you hear music."
				+ "{/nl}Click to next step and stop music."
			
			})
		
	yield(Ren, "story_step")
	if Ren.current_dialog_name == dialog_name:
		# "test bgm 2":
		if id == Ren.story_state:
			id += 1
			Ren.stop_audio("BGMPlayer")
			Ren.say({
				"who":"test", "what":"music was stop."
				+ "{/nl}Click to next step."
			})
		
	yield(Ren, "story_step")
	if Ren.current_dialog_name == dialog_name:
		# example of dict in text
		if id == Ren.story_state:
			id += 1
			Ren.define("test_dict", {"a": 1, "b": 2})
			Ren.say({"who":"test", "what":"test dict b element is [test_dict.b]"})
		
	yield(Ren, "story_step")
	if Ren.current_dialog_name == dialog_name:
		## example of using Ren.variable in text
		if id == Ren.story_state:
			id += 1
			Ren.define("test_list", [1,3,7])
			Ren.say({"who":"test", "what":"test list 2 list element is [test_list[2]]"})
		
	yield(Ren, "story_step")
	if Ren.current_dialog_name == dialog_name:
		## example of updating some Ren.variable
		if id == Ren.story_state:
			id += 1
			Ren.say({"what":"now test_var = [test_var]"})
		
	yield(Ren, "story_step")
	if Ren.current_dialog_name == dialog_name:
		## "test variables 1":
		if id == Ren.story_state:
			id += 1
			Ren.say({"what":"add 1 to test_var"})
			test_var.value += 1
	
	yield(Ren, "story_step")
	if Ren.current_dialog_name == dialog_name:
		if id == Ren.story_state:
			id += 1
			Ren.say({"what":"and now test_var = [test_var]"})
	
	yield(Ren, "story_step")
	if Ren.current_dialog_name == dialog_name:
		## example getting user input to Ren.variable
		if id == Ren.story_state:
			id += 1
			Ren.ask({
				"who": 
					"rench",
				"what":
					"Hi! I'm [rench.name]. What is your name?",
				"variable":
						"player_name", ## Ren variable to be changed
						## it don't have to be define before input
				"value":
					"Developer" ## default value
				})
		
	yield(Ren, "story_step")
	if Ren.current_dialog_name == dialog_name:
		## example of showing text all at once
		if id == Ren.story_state:
			id += 1
			Ren.say({
				"who": 
					"rench",
				"what":
					"Welcome [player_name] in Ren Framework Version [version]",
				"typing":
					false
				})
	
	yield(Ren, "story_step")
	if Ren.current_dialog_name == dialog_name:
		# "test skipping/auto":
		if id == Ren.story_state:
			id += 1
			Ren.say({
				"who": 
					"rench",
				"what":
					"extra stamement to check skipping/auto",
				})
		
	yield(Ren, "story_step")
	if Ren.current_dialog_name == dialog_name:
		# example of creating menu
		# menu will jump other dialog in this scene
		if id == Ren.story_state:
			id += 1
			Ren.hide("rench")
			Ren.menu({
				"who":
					"rench",
				"what":
					"What want to do?",
				"mkind":
					"horizontal",
				"choices":
					[
						"Play Visual Novel example",
						"Play Click'n'Point Adventure example",
						"Play RPG example",
						"Read Docs"
					]
				})
	
	yield(Ren, "story_step")
	if Ren.current_dialog_name == "Play Visual Novel example":
		Ren.jump("VisualNovelExample/Garden", "garden")
	
	yield(Ren, "story_step")
	if Ren.current_dialog_name == "Play Click'n'Point Adventure example":
		Ren.say({
				"who":
					"rench",
				"what":
					"Click'n'Point Adventure example is not ready yet"
			})
			
		Ren.jump("Test/Test", "end", 0, false)
	
	yield(Ren, "story_step")
	if Ren.current_dialog_name == "Play RPG example":
		Ren.say({
			"who":
				"rench",
			"what":
				"RPG example is not ready yet"
		})
		
		Ren.jump("Test/Test", "end", 0, false)
	
	
	yield(Ren, "story_step")
	if Ren.current_dialog_name == "Read Docs":
		Ren.say({
			"who":
				"rench",
			"what":
				"Docs are not ready yet"
		})
		
		Ren.jump("Test/Test", "end", 0, false)
	
	yield(Ren, "story_step")
	if Ren.current_dialog_name == "end":
		Ren.notifiy("You make your first choice!",3)
		Ren.say({
			"who": 
				"rench",
			"what":
				"End of Example",
			})

