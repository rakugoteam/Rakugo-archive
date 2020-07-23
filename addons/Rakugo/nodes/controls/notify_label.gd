tool
extends Label
class_name NotifyLabel, "res://addons/Rakugo/icons/notify_label.svg"

export var normal_color := Color.transparent
export var notify_color := Color.green
export var time_to_show := 1
export var time_of_display := 0.7
export var hide_on_start := true
var tween := Tween.new()

func _ready() -> void:
	if hide_on_start:
		hide()

	add_child(tween)
	tween.connect("tween_all_completed", self, "on_tween_all_completed")


func on_tween_all_completed() -> void:
	if hide_on_start:
		hide()


func notify(_text := text) -> void:
	text = _text

	if hide_on_start:
		show()

	tween.interpolate_property(
		self, "modulate",
		normal_color, notify_color,
		time_to_show, Tween.TRANS_LINEAR, Tween.EASE_IN)

	tween.interpolate_property(
		self, "modulate",
		notify_color, normal_color,
		time_to_show, Tween.TRANS_LINEAR, Tween.EASE_IN, time_of_display)

	tween.start()
