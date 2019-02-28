extends BoxContainer
class_name CollapsedList 

export(Array) var options_list : = []
export(int) var current_choice_id : = 0
export(NodePath) var label_path = "Label"
export(NodePath) var prev_button_path = "PrevButton"
export(NodePath) var next_button_path = "NextButton"

onready var label = get_node(label_path)
onready var prev_button = get_node(prev_button_path)
onready var next_buton = get_node(next_button_path)

func _ready() -> void:
	prev_button.connect("pressed", self, "_on_prev_button")
	next_buton.connect("pressed", self, "_on_next_button")

func update_label(choice : = options_list[current_choice_id]) -> void:
	label.text = choice

func _on_prev_button() -> void:
	if current_choice_id == 0:
		current_choice_id = options_list.size() - 1
	else:
		current_choice_id -= 1
	
	update_label()

func _on_next_button() -> void:
	if current_choice_id == options_list.size() - 1:
		current_choice_id = 0
	else:
		current_choice_id += 1

	update_label()