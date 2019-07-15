extends VBoxContainer

export(PackedScene) var QuestButtonTemplate: PackedScene
export(NodePath) var quests_box_path := "HBoxContainer/ScrollContainer/Quests"
export(NodePath) var subquests_box_path := "HBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/ScrollContainer2/Subquests"
export(NodePath) var quest_label_path := "HBoxContainer/HBoxContainer/VBoxContainer/Title2"
export(NodePath) var quest_des_label_path := "HBoxContainer/HBoxContainer/VBoxContainer/Description"

onready var QuestButton := load(QuestButtonTemplate.resource_path)
onready var quests_box: BoxContainer = get_node(quests_box_path)
onready var subquests_box: BoxContainer = get_node(subquests_box_path)
onready var quest_label: Label = get_node(quest_label_path)
onready var quest_des_label: RakugoTextLabel = get_node(quest_des_label_path)

var current_quest_button: Button
var temp_quests := []

func _ready() -> void:
	connect("visibility_changed", self, "_on_visibility_changed")


func add_quest_button(quest: Subquest, place_to_add: Node, is_subquest := false) -> Object:
	if quest.state == quest.STATE_NOT_AVAILABLE:
		return null

	var q_button: Button = QuestButton.instance()
	q_button.setup(quest)
	q_button.quest_label = quest_label
	q_button.quest_des_label = quest_des_label
	q_button.quests_box = self
	q_button.is_subquest = is_subquest
	place_to_add.add_child(q_button)
	return q_button


func _on_visibility_changed() -> void:
	if not visible:
		return

	if temp_quests == Rakugo.quests:
		return

	var i = 0
	for quest_id in Rakugo.quests:
		if quest_id in temp_quests:
			continue

		var quest: Quest = Rakugo.get_var(quest_id)
		var q_button: Button = add_quest_button(quest, quests_box)
		if i == quests_box.get_child_count():
			if !q_button:
				continue

		temp_quests.append(quest_id)
		if quest.is_subquests_empty():
			continue

		var j = 0
		var sub_box = VBoxContainer.new()
		var subquest: Subquest
		for subquest in quest.get_subquests():
			var subq_button = add_quest_button(subquest, sub_box, true)
			if j == sub_box.get_child_count():
				if !subq_button:
					continue

			j += 1

		if sub_box.get_child_count() > 0:
			subquests_box.add_child(sub_box)
			q_button.quest_sub_box = sub_box
			sub_box.hide()

		else:
			sub_box.queue_free()

		i += 1
