tool
extends RakugoBaseButton
class_name RakugoChoiceButton

var label
var id : = -1

func _ready() -> void:
	disconnect("pressed", self, "_on_pressed")
	connect("pressed", self, "_on_pressed", [], CONNECT_ONESHOT)
	label = $RichTextLabel
	label.mouse_filter = MOUSE_FILTER_IGNORE
	label.bbcode_enabled = true
	node_to_change = label

func _on_pressed() -> void:
	._on_pressed()
	Rakugo.debug(["final_choice", id])
	Rakugo.exit_statement({"final_choice":id})
