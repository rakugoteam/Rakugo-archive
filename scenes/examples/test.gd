## This is example of script using Ren Framework ##

extends Node

func _ready():
	Ren.connect("story_step", self, "story")
	Ren.current_dialog_name = "example"
	Ren.story_state = "start"
	Ren.current_scene = "test.tscn"
	Ren.current_node = self
	Ren.story_step()
	
func story(dialog_name):
	if dialog_name != "example":
		return
		
	match Ren.story_state:
		"start":
			## some tests:
			## example of using Ren.variable in text
			Ren.define("test_list", [1,3,7])
			Ren.say({"who":"test", "what":"test list 2 list element is [test_list[2]]"})
			Ren.story_state = "test variables 0"
		
		"test variables 0":
			## example of updating some Ren.variable
			Ren.define("test_val", 1)
			Ren.say({"what":"now test_val = [test_val]"})
			Ren.story_state = "test variables 1"

		"test variables 1":
			Ren.say({"what":"add 1 to test_val"})
			var tval = Ren.get_variable("test_val")
			tval += 1
			Ren.define("test_val", tval)
			Ren.story_state = "test variables 2"
		
		"test variables 2":
			Ren.say({"what":"and now test_val = [test_val]"})
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
				"input_variable":
						"player_name", ## Ren variable to be changed
						## it don't have to be define before input
				"variable":
					"Developer" ## default variable
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
			Ren.jump("garden", "start")
			Ren.current_scene = "VisualNovelExample/Garden.tscn"
			

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

