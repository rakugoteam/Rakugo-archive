## This is example of script using Ren Framework ##

extends Node

var test_var
var test_quest
var test_subquest

func _ready():
	if Ren.current_root_node != self:
		Ren.current_root_node = self
	
	Ren.jump("Test/Test", "example", 0, false)
	Ren.add_dialog(self, "example")
	Ren.add_dialog(self, "play_vn_example")
	Ren.add_dialog(self, "play_cp_adv_example")
	Ren.add_dialog(self, "play_rpg_example")
	Ren.add_dialog(self, "read_docs")
	Ren.add_dialog(self, "end")
	
	test_var = Ren.define("test_var", 1)
	test_quest = Ren.quest("test_quest")
	test_quest.title = "Test Quest"
	test_quest.description = "Your first epic quest."
	
	test_subquest = Ren.subquest("test_subquest")
	test_subquest.title = "Test Subquest"
	test_subquest.description = "Your first epic subquest."
	test_subquest.optional = true
	test_quest.add_subquest(test_subquest)

func example(dialog_name):
	if dialog_name != "example":
		return
	
	match Ren.story_state:
		0:
			Ren.call_node("TestNode", "test_func", ["test of call node"])
			Ren.say({"what": "Test of call in func form node using call_node."})
	
		1:
			test_quest.start()
			Ren.say({"what": "For test quest system now will you start test quest."})
		
		2:
			test_quest.finish()
			Ren.say({"what": "And now test quest is done."})
	
		3:
			Ren.play_anim("TestAnimPlayer", "test")
			Ren.say({"who":"test", "what":"test of playing simple anim"})
	
		4:
			Ren.stop_anim("TestAnimPlayer", true)
			Ren.play_anim("TestAnimPlayer", "test_loop")
			Ren.say({
				"who":"test",
				"what":"test of stoping loop anim."+
				"{/nl}Click to go next step and stop anim"
			})
	
		6:
			Ren.stop_anim("TestAnimPlayer", true)
			Ren.say({
				"who":"test",
				"what":"test anim stopped"
			})
		
		7:
			Ren.play_audio("SFXPlayer")
			Ren.say({"who":"test", "what":"now you hear sfx."})

		8:
			Ren.play_audio("BGMPlayer")
			Ren.say({
				"who":"test", "what":"now you hear music."
				+ "{/nl}Click to next step and stop music."
			
			})
		
		9:
			Ren.stop_audio("BGMPlayer")
			Ren.say({
				"who":"test", "what":"music was stop."
				+ "{/nl}Click to next step."
			})
		
		10:
			Ren.define("test_dict", {"a": 1, "b": 2})
			Ren.say({"who":"test", "what":"test dict b element is [test_dict.b]"})
		
		11:
			Ren.define("test_list", [1,3,7])
			Ren.say({"who":"test", "what":"test list 2 list element is [test_list[2]]"})
		
		12:
			Ren.say({"what":"now test_var = [test_var]"})
		
		13:
			Ren.say({"what":"add 1 to test_var"})
			test_var.value += 1
	
		14:
			Ren.say({"what":"and now test_var = [test_var]"})
	
		15:
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
		
		16:
			Ren.say({
				"who": 
					"rench",
				"what":
					"Welcome [player_name] in Ren Framework Version [version]",
				"typing":
					false
				})
	
		17:
			Ren.say({
				"who": 
					"rench",
				"what":
					"extra stamement to check skipping/auto",
				})


		18:
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
	
func play_vn_example(dialog_name):
	if dialog_name != "Play Visual Novel example":
		return
		
	Ren.jump("VisualNovelExample/Garden", "garden")
	
func play_cp_adv_example(dialog_name):	
	if dialog_name != "Play Click'n'Point Adventure example":
		return
		
	Ren.say({
			"who":
				"rench",
			"what":
				"Click'n'Point Adventure example is not ready yet"
		})
		
	Ren.jump("Test/Test", "end", 0, false)
	
func play_rpg_example(dialog_name):
	if Ren.current_dialog_name == "Play RPG example":
		Ren.say({
			"who":
				"rench",
			"what":
				"RPG example is not ready yet"
		})
		
		Ren.jump("Test/Test", "end", 0, false)
	
	
func read_docs(dialog_name):
	if dialog_name != "Read Docs":
		return
		
	Ren.say({
		"who":
			"rench",
		"what":
			"Docs are not ready yet"
	})
	
	Ren.jump("Test/Test", "end", 0, false)

func end(dialog_name):
	if dialog_name != "end":
		return
		
	Ren.notifiy("You make your first choice!",3)
	Ren.say({
		"who": 
			"rench",
		"what":
			"End of Example",
		})

