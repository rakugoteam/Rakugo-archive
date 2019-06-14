## This is example of script using Rakugo Framework ##

extends GDScriptDialog

var test_var
var test_quest
var test_subquest

func _ready():
	test_var = define("test_var", 1)
	test_quest = quest("test_quest")
	test_quest.title = "Test Quest"
	test_quest.description = "Your first epic quest."

	test_subquest = subquest("test_subquest")
	test_subquest.title = "Test Subquest"
	test_subquest.description = "Your first epic subquest."
	test_subquest.optional = true
	test_quest.add_subquest(test_subquest)

func example(node_name, dialog_name):
	var cd = check_dialog(node_name, dialog_name, "example")
	
	if not cd:
		return

	match get_story_state():
		0:
			call_node("TestNode", "test_func", ["test of call node"])
			say({
				"what": "Test of call in func form node using call_node."
			})

		1:
			test_quest.start()
			say({
				"what": "For test quest system now will you start test quest."
			})

		2:
			test_quest.finish()
			say({
				"what": "And now test quest is done."
			})

		3:
			play_anim("TestAnimPlayer", "test")
			say({"who":"test", "what":"test of playing simple anim"
			})

		4:
			stop_anim("TestAnimPlayer", true)
			play_anim("TestAnimPlayer", "test_loop")
			say({
				"who":"test",
				"what":
				"Test of stoping loop anim." +
				"{/nl}Click to go next step and stop anim"
			})

		5:
			stop_anim("TestAnimPlayer", true)
			say({
				"who":"test",
				"what":"test anim stopped"
			})

		6:
			play_audio("SFXPlayer")
			say({
				"who":"test", "what":"now you hear sfx."
			})

		7:
			play_audio("BGMPlayer")
			say({
				"who":"test", "what":
				"Now you hear music." +
				"{/nl}Click to next step and stop music."
			})

		8:
			stop_audio("BGMPlayer")
			say({
				"who":"test", "what":
				"Music was stop." +
				"{/nl}Click to next step."
			})

		9:
			define(
			"test_dict", {"a": 1, "b": 2})
			say({
				"who":"test",
				"what":"test dict b element is [test_dict.b]"
			})

		10:
			define("test_list", [1,3,7])
			say({
				"who":"test",
				"what":"test list 2 list element is [test_list[2]]"
			})

		11:
			say({"what":"now test_var = [test_var]"})

		12:
			say({"what":"add 1 to test_var"})
			test_var.value += 1

		13:
			say({"what":"and now test_var = [test_var]"})

		14:
			ask({
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

		15:
			say({
				"who":
					"ra",
				"what":
					"Welcome [player_name] in Rakugo Framework Version [version]",
				"typing":
					false
			})

		16:
			say({
				"who":
					"ra",
				"what":
					"extra stamement to check skipping/auto"
			})

		17:
			hide("ra")
			menu({
				"who":
					"ra",
				"what":
					"What want to do?",
				"mkind":
					"horizontal",
				"choices":
					{
						"Play Visual Novel example" : "play_vn",
						"Play Click'n'Point Adventure example" : "play_adv",
						"Play RPG example" : "play_rpg",
						"Read Docs" : "read_docs"
					}
			})

func play_vn(node_name, dialog_name):
	if not check_dialog(node_name, dialog_name, "play_vn"):
		return

	jump("Garden", "Garden", "garden")

func play_adv(node_name, dialog_name):
	if not check_dialog(node_name, dialog_name, "play_adv"):
		return

	match get_story_state():
		0:
			say({
				"who":
					"ra",
				"what":
					"Click'n'Point Adventure example is not ready yet"
			})
		1:
			jump("Test", name, "end", false)

func play_rpg(node_name, dialog_name):
	if not check_dialog(node_name, dialog_name, "play_vn"):
		return

	match get_story_state():
		0:
			say({
				"who":
					"ra",
				"what":
					"RPG example is not ready yet"
				})
		1:
			jump("Test", name, "end", false)

func read_docs(node_name, dialog_name):
	if not check_dialog(node_name, dialog_name, "read_docs"):
		return

	match get_story_state():
		0:
			say({
				"who":
					"ra",
				"what":
					"Docs are not ready yet"
				})
		1:
			jump("Test", name, "end", false)

func end(node_name, dialog_name):
	if not check_dialog(node_name, dialog_name, "end"):
		return

	match get_story_state():
		0:
			notify("You make your first choice!", 3)
			say({
				"who":
					"ra",
				"what":
					"End of Example"
				})
