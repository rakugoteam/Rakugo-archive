extends VBoxContainer

export(PackedScene) var QuestButtonTemplate
onready var QuestButton = load(QuestButtonTemplate.resource_path)
var temp_quests = []
onready var quests_box = $HBoxContainer/ScrollContainer/Quests
onready var subquests_box = $HBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/ScrollContainer2/Subquests
onready var quest_label = $HBoxContainer/HBoxContainer/VBoxContainer/Title2
onready var quest_des_label = $HBoxContainer/HBoxContainer/VBoxContainer/Description

func _ready():
	connect("visibility_changed", self, "_on_visibility_changed")

func add_quest_button(quest, place_to_add):
	if quest.state == quest.STATE_NOT_AVAILABLE:
		return false

	var q_button = QuestButton.instance()
	q_button.setup(quest)
	q_button.quest_label = quest_label
	q_button.quest_des_label = quest_des_label
	place_to_add.add_child(q_button)
	return true

func _on_visibility_changed():
	if not visible:
		return
	
	if temp_quests == Ren.quests:
		return
	
	var i = 0
	for quest_id in Ren.quests:
		var quest = Ren.get_quest(quest_id)
		
		if i == quests_box.get_child_count():
			if not add_quest_button(quest, quests_box):
				continue
		
		if quest.subquests.empty():
			continue
		
		var j = 0
		var sub_box = VBoxContainer.new()
		for subquest in quest.subquests:
			if j == sub_box.get_child_count():
				if not add_quest_button(subquest, sub_box):
					continue
			j += 1
		if sub_box.get_child_count() > 0:
			subquests_box.add_child(sub_box)
		else:
			sub_box.queue_free()
		i += 1

	temp_quests = Ren.quests.duplicate()






		

