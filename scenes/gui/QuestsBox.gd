extends VBoxContainer

export(PackedScene) var QuestButtonTemplate
onready var QuestButton = load(QuestButtonTemplate.resource_path)
var temp_quests = []
onready var quests_box = $HBoxContainer/ScrollContainer/Quests
onready var subquests_box = $HBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/ScrollContainer2/Subquests
onready var quest_label = $HBoxContainer/HBoxContainer/VBoxContainer/Title2
onready var quest_des_gui = $HBoxContainer/HBoxContainer/VBoxContainer/Description

func _ready():
	connect("visibility_changed", self, "_on_visibility_changed")

func add_quest_button(quest, place_to_add):
	if quest.state == quest.STATE_NOT_AVAILABLE:
		return false

	var q_button = QuestButton.instance()
	q_button.setup(quest)
	q_button.quest_label = quest_label
	q_button.quest_des_gui = quest_des_gui
	place_to_add.add_child(q_button)
	return true
	

func _on_visibility_changed():
	if not visible:
		return
	
	if temp_quests == Ren.quests:
		return
	
	for quest_id in Ren.quests:
		var quest = Ren.get_quest(quest_id)
		
		if not add_quest_button(quest, quests_box):
			continue
		
		if quest.subquests.empty():
			continue
		
		var sub_box = VBoxContainer.new()
		for subquest in quest.subquests:
			
			if not add_quest_button(subquest, sub_box):
				continue
		
		subquests_box.add(sub_box)






		

