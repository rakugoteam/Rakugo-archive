extends "ren_base_button.gd"

export(Vector2) var sprite_rect = Vector2(64, 64)
var quest
var quest_label
var quest_des_label
var quest_sub_box
var quests_box
var is_subquest = false

func _ready():
	node_to_change = $RichTextLabel

func _on_resized():
	._on_resized()
	var sprite_pos = rect_size
	sprite_pos.x -= sprite_rect.x/2
	sprite_pos.y -= sprite_rect.y/2
	$AnimatedSprite.position = sprite_pos


func setup(quest_to_use):
	quest = quest_to_use
	on_title_changed(quest.title)
	on_optional_changed(quest.optional)
	on_state_changed(quest.state)

	quest.connect("title_changed", self, "on_title_changed")
	quest.connect("description_changed", self, "on_description_changed")
	quest.connect("optional_changed", self, "on_optional_changed")
	quest.connect("state_changed", self, "on_state_changed")

func on_title_changed(new_title):
	$RichTextLabel.bbcode_text = quest.title
	if pressed:
		quest_label.text = quest.title

func on_optional_changed(opt):
	if opt:
		$AnimatedSprite.animation = "opt"
	else:
		$AnimatedSprite.animation = "default"

func on_state_changed(new_state):
	$AnimatedSprite.frame = abs(new_state - 1)

func _on_pressed():
	._on_pressed()
	quest_label.text = quest.title
	quest_des_label.bbcode_text = Ren.text_passer(quest.description)
	if is_subquest:
		return

	if quests_box.current_quest_button != null:
		if quests_box.current_quest_button.quest_sub_box != quest_sub_box:
			quests_box.current_quest_button.quest_sub_box.hide()
		
	if quest_sub_box != null:
		quest_sub_box.show()
		quests_box.current_quest_button = self

func on_description_changed(new_des):
	if pressed:
		quest_des_label.bbcode_text = Ren.text_passer(new_des)
