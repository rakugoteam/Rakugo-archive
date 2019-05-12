## This is example of script using Rakugo Framework ##

extends Node

var test_var
var test_quest
var test_subquest

func _ready():
	if Rakugo.current_root_node != self:
		Rakugo.current_root_node = self

	Rakugo.begin("Test", name, "example")
	Rakugo.add_dialog(self, "example")
	Rakugo.add_dialog(self, "play_vn_example")
	Rakugo.add_dialog(self, "play_cp_adv_example")
	Rakugo.add_dialog(self, "play_rpg_example")
	Rakugo.add_dialog(self, "read_docs")
	Rakugo.add_dialog(self, "end")

	test_var = Rakugo.define("test_var", 1)
	test_quest = Rakugo.quest("test_quest")
	test_quest.title = "Test Quest"
	test_quest.description = "Your first epic quest."

	test_subquest = Rakugo.subquest("test_subquest")
	test_subquest.title = "Test Subquest"
	test_subquest.description = "Your first epic subquest."
	test_subquest.optional = true
	test_quest.add_subquest(test_subquest)

func example(node_name, dialog_name):
	if node_name != name:
		return

	if dialog_name != "example":
		return

	Rakugo.call_node("TestNode", "test_func", ["test of call node"])
	Rakugo.say({"what": "Test of call in func form node using call_node."})
	yield(Rakugo, "story_step")

	test_quest.start()
	Rakugo.say({"what": "For test quest system now will you start test quest."})
	yield(Rakugo, "story_step")

	test_quest.finish()
	Rakugo.say({"what": "And now test quest is done."})
	yield(Rakugo, "story_step")

	Rakugo.play_anim("TestAnimPlayer", "test")
	Rakugo.say({"who":"test", "what":"test of playing simple anim"})
	yield(Rakugo, "story_step")

	Rakugo.stop_anim("TestAnimPlayer", true)
	Rakugo.play_anim("TestAnimPlayer", "test_loop")
	Rakugo.say({
		"who":"test",
		"what":
		"Test of stoping loop anim." +
		"{/nl}Click to go next step and stop anim"
	})
	yield(Rakugo, "story_step")

	Rakugo.stop_anim("TestAnimPlayer", true)
	Rakugo.say({
		"who":"test",
		"what":"test anim stopped"
	})
	yield(Rakugo, "story_step")

	Rakugo.play_audio("SFXPlayer")
	Rakugo.say({"who":"test", "what":"now you hear sfx."})
	yield(Rakugo, "story_step")

	Rakugo.play_audio("BGMPlayer")
	Rakugo.say({
		"who":"test", "what":
		"Now you hear music." +
		"{/nl}Click to next step and stop music."

	})
	yield(Rakugo, "story_step")

	Rakugo.stop_audio("BGMPlayer")
	Rakugo.say({
		"who":"test", "what":
		"Music was stop." +
		"{/nl}Click to next step."
	})
	yield(Rakugo, "story_step")

	Rakugo.define("test_dict", {"a": 1, "b": 2})
	Rakugo.say({"who":"test", "what":"test dict b element is [test_dict.b]"})
	yield(Rakugo, "story_step")

	Rakugo.define("test_list", [1,3,7])
	Rakugo.say({"who":"test", "what":"test list 2 list element is [test_list[2]]"})
	yield(Rakugo, "story_step")

	Rakugo.say({"what":"now test_var = [test_var]"})
	yield(Rakugo, "story_step")

	Rakugo.say({"what":"add 1 to test_var"})
	test_var.value += 1
	yield(Rakugo, "story_step")

	Rakugo.say({"what":"and now test_var = [test_var]"})
	yield(Rakugo, "story_step")

	Rakugo.ask({
		"who":
			"ra",
		"what":
			"Hi! I'm [ra.name]. What is your name?",
		"variable":
				"player_name", ## Rakugo variable to be changed
				## it don't have to be define before input
		"value":
			"Developer" ## default value
		})
	yield(Rakugo, "story_step")

	Rakugo.say({
		"who":
			"ra",
		"what":
			"Welcome [player_name] in Rakugo Framework Version [version]",
		"typing":
			false
		})
	yield(Rakugo, "story_step")

	Rakugo.say({
		"who":
			"[player_name]",
		"what":
			"Nice to be here.",
	})
	yield(Rakugo, "story_step")

	Rakugo.say({
		"who":
			"ra",
		"what":
			"extra stamement to check skipping/auto",
		})
	yield(Rakugo, "story_step")
	
	Rakugo.hide("ra")
	Rakugo.menu({
		"who":
			"ra",
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

func play_vn_example(node_name, dialog_name):
	if node_name != name:
		return

	if dialog_name != "Play Visual Novel example":
		return

	Rakugo.jump("Garden", "Garden", "garden")

func play_cp_adv_example(node_name, dialog_name):
	if node_name != name:
		return

	if dialog_name != "Play Click'n'Point Adventure example":
		return

	Rakugo.say({
			"who":
				"ra",
			"what":
				"Click'n'Point Adventure example is not ready yet"
		})

	Rakugo.jump("Test", name, "end", false)

func play_rpg_example(node_name, dialog_name):
	if node_name != name:
		return

	if Rakugo.current_dialog_name == "Play RPG example":
		Rakugo.say({
			"who":
				"ra",
			"what":
				"RPG example is not ready yet"
		})

		Rakugo.jump("Test", name, "end", false)


func read_docs(node_name, dialog_name):
	if node_name != name:
		return

	if dialog_name != "Read Docs":
		return

	Rakugo.say({
		"who":
			"ra",
		"what":
			"Docs are not ready yet"
	})

	Rakugo.jump("Test", name, "end", false)

func end(node_name, dialog_name):
	if node_name != name:
		return

	if dialog_name != "end":
		return

	Rakugo.notifiy("You make your first choice!",3)
	Rakugo.say({
		"who":
			"ra",
		"what":
			"End of Example",
		})
