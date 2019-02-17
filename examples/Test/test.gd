## This is example of script using Ren Framework ##

extends Node

var test_var
var test_quest
var test_subquest

func _ready():
#	Ren.connect("story_step", self, "story")
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
	
	if dialog_name != yield(Ren, "story_step"):
		return
		
	Ren.call_node("TestNode", "test_func", ["test of call node"])
	Ren.say({"what": "Test of call in func form node using call_node."})

	# test of quest system part1
	if dialog_name != yield(Ren, "story_step"):
		return
	test_quest.start()
	Ren.say({"what": "For test quest system now will you start test quest."})
	
	if dialog_name != yield(Ren, "story_step"):
		return
	test_quest.finish()
	Ren.say({"what": "And now test quest is done."})

#	"test play_anim":
	if dialog_name != yield(Ren, "story_step"):
		return
	Ren.play_anim("TestAnimPlayer", "test")
	Ren.say({"who":"test", "what":"test of playing simple anim"})
#			Ren.story_state = "test stop_anim 1"
		

#	"test stop_anim 1":
	if dialog_name != yield(Ren, "story_step"):
		return
	Ren.stop_anim("TestAnimPlayer", true)
	Ren.play_anim("TestAnimPlayer", "test_loop")
	Ren.say({
		"who":"test",
		"what":"test of stoping loop anim."+
		"{/nl}Click to go next step and stop anim"
	})

#	"test stop_anim 2":
	if dialog_name != yield(Ren, "story_step"):
		return
	Ren.stop_anim("TestAnimPlayer", true)
	Ren.say({
		"who":"test",
		"what":"test anim stopped"
	})


#	"test sfx":
	if dialog_name != yield(Ren, "story_step"):
		return
	Ren.play_audio("SFXPlayer")
	Ren.say({"who":"test", "what":"now you hear sfx."})

#	"test bgm 1":
	if dialog_name != yield(Ren, "story_step"):
		return
	Ren.play_audio("BGMPlayer")
	Ren.say({
		"who":"test", "what":"now you hear music."
		+ "{/nl}Click to next step and stop music."
	
	})

#	"test bgm 2":
	if dialog_name != yield(Ren, "story_step"):
		return
	Ren.stop_audio("BGMPlayer")
	Ren.say({
		"who":"test", "what":"music was stop."
		+ "{/nl}Click to next step."
	
	})

	# example of dict in text
	if dialog_name != yield(Ren, "story_step"):
		return
	Ren.define("test_dict", {"a": 1, "b": 2})
	Ren.say({"who":"test", "what":"test dict b element is [test_dict.b]"})

	## example of using Ren.variable in text
	if dialog_name != yield(Ren, "story_step"):
		return
	Ren.define("test_list", [1,3,7])
	Ren.say({"who":"test", "what":"test list 2 list element is [test_list[2]]"})
	
	## example of updating some Ren.variable
	if dialog_name != yield(Ren, "story_step"):
		return
	Ren.say({"what":"now test_var = [test_var]"})

#	"test variables 1":
	if dialog_name != yield(Ren, "story_step"):
		return
	Ren.say({"what":"add 1 to test_var"})
	test_var.value += 1

	if dialog_name != yield(Ren, "story_step"):
		return
	Ren.say({"what":"and now test_var = [test_var]"})

	## example getting user input to Ren.variable
	if dialog_name != yield(Ren, "story_step"):
		return
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

	## example of showing text all at once
	if dialog_name != yield(Ren, "story_step"):
		return
	Ren.say({
		"who": 
			"rench",
		"what":
			"Welcome [player_name] in Ren Framework Version [version]",
		"typing":
			false
		})

#	"test skipping/auto":
	if dialog_name != yield(Ren, "story_step"):
		return
	Ren.say({
		"who": 
			"rench",
		"what":
			"extra stamement to check skipping/auto",
		})

#		"example of menu":
#			# example of creating menu
#			# menu set story_state it self
#			# Ren.hide("rench")
#			Ren.menu({
#				"who":
#					"rench",
#				"what":
#					"What want to do?",
#				"mkind":
#					"horizontal",
#				"choices":
#					[
#						"Play Visual Novel example",
#						"Play Click'n'Point Adventure example",
#						"Play RPG example",
#						"Read Docs"
#					]
#				})
#
#		"Play Visual Novel example":
#			Ren.jump("VisualNovelExample/Garden", "garden")
#
#		"Play Click'n'Point Adventure example":
#			Ren.say({
#				"who":
#					"rench",
#				"what":
#					"Click'n'Point Adventure example is not ready yet"
#			})
#			Ren.story_state = "end"
#
#		"Play RPG example":
#			Ren.say({
#				"who":
#					"rench",
#				"what":
#					"RPG example is not ready yet"
#			})
#			Ren.story_state = "end"
#
#		"Read Docs":
#			Ren.say({
#				"who":
#					"rench",
#				"what":
#					"Docs are not ready yet"
#			})
#			Ren.story_state = "end"
		
#		"end":
#			Ren.notifiy("You make your first choice!",3)
#			Ren.say({
#				"who": 
#					"rench",
#				"what":
#					"End of Example",
#				})

