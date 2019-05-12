## This is example of script using Rakugo Framework ##

extends Node

export (String, "adv", "hide", "top", "center", "left", "right", "nvl") var kind = "adv"
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

	match Rakugo.story_state:
		0:
			Rakugo.call_node("TestNode", "test_func", ["test of call node"])
			Rakugo.say({
				"what": "Test of call in func form node using call_node.",
				"kind": kind
			})

		1:
			test_quest.start()
			Rakugo.say({
				"what": "For test quest system now will you start test quest.",
				"kind": kind
			})

		2:
			test_quest.finish()
			Rakugo.say({
				"what": "And now test quest is done.",
				"kind": kind
			})

		3:
			Rakugo.play_anim("TestAnimPlayer", "test")
			Rakugo.say({
				"who":"test",
				"what":"test of playing simple anim",
				"kind": kind
			})

		4:
			Rakugo.stop_anim("TestAnimPlayer", true)
			Rakugo.play_anim("TestAnimPlayer", "test_loop")
			Rakugo.say({
				"who":"test",
				"what":
				"Test of stoping loop anim." +
				"{/nl}Click to go next step and stop anim",
				"kind": kind
			})

		6:
			Rakugo.stop_anim("TestAnimPlayer", true)
			Rakugo.say({
				"who":"test",
				"what":"test anim stopped",
				"kind": kind
			})

		7:
			Rakugo.play_audio("SFXPlayer")
			Rakugo.say({
				"who":"test", "what":"now you hear sfx.",
				"kind": kind
			})

		8:
			Rakugo.play_audio("BGMPlayer")
			Rakugo.say({
				"who":"test", "what":
				"Now you hear music." +
				"{/nl}Click to next step and stop music.",
				"kind": kind
			})

		9:
			Rakugo.stop_audio("BGMPlayer")
			Rakugo.say({
				"who":"test", "what":
				"Music was stop." +
				"{/nl}Click to next step.",
				"kind": kind
			})

		10:
			Rakugo.define("test_dict", {"a": 1, "b": 2})
			Rakugo.say({
				"who":"test",
				"what":"test dict b element is [test_dict.b]",
				"kind": kind
			})

		11:
			Rakugo.define("test_list", [1,3,7])
			Rakugo.say({
				"who":"test",
				"what":"test list 2 list element is [test_list[2]]",
				"kind": kind
			})

		12:
			Rakugo.say({
				"what":"now test_var = [test_var]",
				"kind": kind
			})

		13:
			Rakugo.say({
				"what":"add 1 to test_var",
				"kind": kind
			})
			test_var.value += 1

		14:
			Rakugo.say({
				"what":"and now test_var = [test_var]",
				"kind": kind
			})

		15:
			Rakugo.ask({
				"who":
					"ra",
				"what":
					"Hi! I'm [ra.name]. What is your name?",
				"variable":
						"player_name", ## Rakugo variable to be changed
						## it don't have to be define before input
				"value":
					"Developer", ## default value,
				"kind": kind
			})

		16:
			Rakugo.say({
				"who":
					"ra",
				"what":
					"Welcome [player_name] in Rakugo Framework Version [version]",
				"typing":
					false,
				"kind": kind
			})

		17:
			Rakugo.say({
				"who":
					"ra",
				"what":
					"extra stamement to check skipping/auto",
				"kind": kind
			})


		18:
			Rakugo.hide("ra")
			Rakugo.menu({
				"who":
					"ra",
				"what":
					"What want to do?",
				"mkind":
					"horizontal",
				"choices":
					{
						"Play Visual Novel example" : "vn",
						"Play Click'n'Point Adventure example" : "cp",
						"Play RPG example" : "rpg",
						"Read Docs" : "docs"
					},
				"kind": kind
			})

func play_vn_example(node_name, dialog_name):
	if node_name != name:
		return

	if dialog_name != "vn":
		return

	Rakugo.jump("Garden", "Garden", "garden")

func play_cp_adv_example(node_name, dialog_name):
	if node_name != name:
		return

	if dialog_name != "cp":
		return

	Rakugo.say({
			"who":
				"ra",
			"what":
				"Click'n'Point Adventure example is not ready yet",
				"kind": kind
			})

	Rakugo.jump("Test", name, "end", false)

func play_rpg_example(node_name, dialog_name):
	if node_name != name:
		return

	if Rakugo.current_dialog_name == "rpg":
		Rakugo.say({
			"who":
				"ra",
			"what":
				"RPG example is not ready yet",
				"kind": kind
			})

		Rakugo.jump("Test", name, "end", false)


func read_docs(node_name, dialog_name):
	if node_name != name:
		return

	if dialog_name != "docs":
		return

	Rakugo.say({
		"who":
			"ra",
		"what":
			"Docs are not ready yet",
				"kind": kind
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
				"kind": kind
			})
