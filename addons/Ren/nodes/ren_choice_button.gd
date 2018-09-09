extends "ren_base_button.gd"

onready var label = RichTextLabel.new()
var id = -1

func _ready():
	disconnect("pressed", self, "_on_pressed")
	connect("pressed", self, "_on_pressed", [], CONNECT_ONESHOT)
	label.mouse_filter = MOUSE_FILTER_IGNORE
	label.bbcode_enabled = true
	add_child(label)
	node_to_change = label

func _on_pressed():
	._on_pressed()
	print("final_choice ", id)
	Ren.exit_statement({"final_choice":id})
