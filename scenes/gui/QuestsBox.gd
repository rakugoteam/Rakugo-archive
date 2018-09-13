extends VBoxContainer

export(PackedScene) var QuestButtonTemplate
onready var QuestButton = load(QuestButtonTemplate.resource_path)
var temp_quests = []
onready var quests_box = $HBoxContainer/ScrollContainer/Quests
onready var subquests_box = $HBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/ScrollContainer2/Subquests
onready var quest_label = $HBoxContainer/HBoxContainer/VBoxContainer/Title2
onready var quest_des_label = $HBoxContainer/HBoxContainer/VBoxContainer/Description
var current_quest_button

func _ready():
	connect("visibility_changed", self, "_on_visibility_changed")

func add_quest_button(quest, place_to_add, is_subquest = false):
	if quest.state == quest.STATE_NOT_AVAILABLE:
		return null

	var q_button = QuestButton.instance()
	q_button.setup(quest)
	q_button.quest_label = quest_label
	q_button.quest_des_label = quest_des_label
	q_button.quests_box = self
	q_button.is_subquest = is_subquest
	place_to_add.add_child(q_button)
	return q_button

func _on_visibility_changed():
	if not visible:
		return
	
	if temp_quests == Ren.quests:
		return
	
	var i = 0
	for quest_id in Ren.quests:
		if quest_id in temp_quests:
			continue
		
		var quest = Ren.get_quest(quest_id)
		var q_button = add_quest_button(quest, quests_box)
		if i == quests_box.get_child_count():
			if q_button == null:
				continue
		
		temp_quests.append(quest_id)
		if quest.subquests.empty():
			continue
		
		var j = 0
		var sub_box = VBoxContainer.new()
		for subquest in quest.subquests:
			var subq_button = add_quest_button(subquest, sub_box, true)
			if j == sub_box.get_child_count():
				if subq_button == null:
					continue
				
			j += 1
		if sub_box.get_child_count() > 0:
			subquests_box.add_child(sub_box)
			q_button.quest_sub_box = sub_box
			sub_box.hide()
		else:
			sub_box.queue_free()
		
		i += 1
		






		

