## This is example of script using Ren Framework ##

extends Node

var test_var
var test_quest
var test_subquest

func _ready():
	Ren.connect("story_step", self, "story")
	Ren.jump("Test", "example", "start", false)

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


func story(dialog_name):
	if dialog_name != "example":
		return

	match Ren.story_state:
		## some tests:
		"start":
			# test of quest system part1
			test_quest.start()
			Ren.say({"what": "For test quest system now will you start test quest."})
			Ren.story_state = "qtest2"

		"qtest2":
			test_quest.finish()
			Ren.say({"what": "And now test quest is done."})
			Ren.story_state = "test play_anim"


		"test play_anim":
			Ren.play_anim("TestAnimPlayer", "test", false)
			Ren.say({"who":"test", "what":"test of simple anim"})
			Ren.story_state = "test dict"

		"test dict":
			# example of dict in text
			Ren.define("test_dict", {"a": 1, "b": 2})
			Ren.say({"who":"test", "what":"test dict b element is [test_dict.b]"})
			Ren.story_state = "test list"
		
		"test list":
			## example of using Ren.variable in text
			Ren.define("test_list", [1,3,7])
			Ren.say({"who":"test", "what":"test list 2 list element is [test_list[2]]"})
			Ren.story_state = "test variables 0"
			
		"test variables 0":
			## example of updating some Ren.variable
			Ren.say({"what":"now test_var = [test_var]"})
			Ren.story_state = "test variables 1"

		"test variables 1":
			Ren.say({"what":"add 1 to test_var"})
			test_var.value += 1
			Ren.story_state = "test variables 2"
		
		"test variables 2":
			Ren.say({"what":"and now test_var = [test_var]"})
			Ren.story_state = "get player name"

		"get player name":
			## showing Ren's node or character with id 'rench' at center
			Ren.show("rench", [], {"at":["center"]})
			## example getting user input to Ren.variable
			Ren.ask({
				"who": 
					"rench",
				"what":
					"Hi! I'm Ren. What is your name?",
				"variable":
						"player_name", ## Ren variable to be changed
						## it don't have to be define before input
				"value":
					"Developer" ## default value
				})
			Ren.story_state = "welcome player"
		
		"welcome player":
			## example of showing text slow
			Ren.say({
				"who": 
					"rench",
				"what":
					"Welcome [player_name] in Ren Framework Version [version]",
				"speed":
					0.1
				})
			Ren.story_state = "test skipping/auto"
		
		"test skipping/auto":
			Ren.say({
				"who": 
					"rench",
				"what":
					"extra stamement to check skipping/auto",
				})
			
			Ren.story_state = "example of menu"

		"example of menu":
			# example of creating menu
			# menu set story_state it self
			# Ren.hide("rench")
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
			
		"Play Visual Novel example":
			Ren.jump("VisualNovelExample/Garden", "garden")
			

		"Play Click'n'Point Adventure example":
			Ren.say({
				"who":
					"rench",
				"what":
					"Click'n'Point Adventure example is not ready yet"
			})
			Ren.story_state = "end"

		"Play RPG example":
			Ren.say({
				"who":
					"rench",
				"what":
					"RPG example is not ready yet"
			})
			Ren.story_state = "end"
		
		"Read Docs":
			Ren.say({
				"who":
					"rench",
				"what":
					"Docs are not ready yet"
			})
			Ren.story_state = "end"
		
		"end":
			Ren.notifiy("You make your first choice!",3)
			Ren.say({
				"who": 
					"rench",
				"what":
					"End of Example",
				})

