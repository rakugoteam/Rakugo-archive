extends "ren_base_button.gd"

export(Vector2) var sprite_rect = Vector2(64, 64)
var quest
var quest_label
var quest_des_gui

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
	quest.connect("optional_changed", self, "on_optional_changed")
	quest.connect("state_changed", self, "on_state_changed")

func on_title_changed(new_title):
	$RichTextLabel.text = quest.title

func on_optional_changed(opt):
	if opt:
		$AnimatedSprite.animation = "opt"
	else:
		$AnimatedSprite.animation = "default"

func on_state_changed(new_state):
	$AnimatedSprite.frame = abs(new_state - 1)