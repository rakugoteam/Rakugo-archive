extends RakugoBaseButton
class_name RakugoQuestButton

export var sprite_rect := Vector2(64, 64)
var quest: Subquest
var quest_label: Label
var quest_des_label: RichTextLabel
var quest_sub_box: BoxContainer
var quests_box: BoxContainer
var is_subquest := false

func _ready() -> void:
	node_to_change = $RichTextLabel


func _on_resized() -> void:
	._on_resized()
	var sprite_pos = rect_size
	sprite_pos.x -= sprite_rect.x / 2
	sprite_pos.y -= sprite_rect.y / 2
	$AnimatedSprite.position = sprite_pos


func setup(quest_to_use: Subquest) -> void:
	quest = quest_to_use
	on_title_changed(quest.title)
	on_optional_changed(quest.optional)
	on_state_changed(quest.state)

	quest.connect("title_changed", self, "on_title_changed")
	quest.connect("description_changed", self, "on_description_changed")
	quest.connect("optional_changed", self, "on_optional_changed")
	quest.connect("state_changed", self, "on_state_changed")


func on_title_changed(new_title: String) -> void:
	$RichTextLabel.bbcode_text = quest.title
	if pressed:
		quest_label.text = quest.title


func on_optional_changed(opt: bool) -> void:
	if opt:
		$AnimatedSprite.animation = "opt"
	else:
		$AnimatedSprite.animation = "default"


func on_state_changed(new_state: int) -> void:
	$AnimatedSprite.frame = abs(new_state - 1)


func _on_pressed() -> void:
	._on_pressed()
	quest_label.text = quest.title
	quest_des_label.bbcode_text = Rakugo.text_passer(quest.description)
	if is_subquest:
		return

	if quests_box.current_quest_button != null:
		if quests_box.current_quest_button.quest_sub_box != quest_sub_box:
			quests_box.current_quest_button.quest_sub_box.hide()
		
	if quest_sub_box != null:
		quest_sub_box.show()
		quests_box.current_quest_button = self


func on_description_changed(new_des: String) -> void:
	if pressed:
		quest_des_label.bbcode_text = Rakugo.text_passer(new_des)
