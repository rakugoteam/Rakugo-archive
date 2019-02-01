extends VBoxContainer

export(PackedScene) var HistoryItemTemplate : PackedScene
onready var HistoryItem : = load(HistoryItemTemplate.resource_path)
var temp_history : = []

func _ready() -> void:
	connect("visibility_changed", self, "_on_visibility_changed")

func add_history_item(type : int, parameters : Dictionary) -> void:
	var new_hi = HistoryItem.instance()
	set_history_item(new_hi, type, parameters)
	add_child(new_hi)

func set_history_item(hi : Node, type : int, parameters : Dictionary):
	var label = hi.get_node("VBox/Label")
	var dialog_text = hi.get_node("VBox/Dialog")
	label.bbcode_text = ""
	dialog_text.bbcode_text = ""
	
	if "who" in parameters:
		label.bbcode_text = parameters.who

	if "what" in parameters:
		dialog_text.bbcode_text = parameters.what

	if type in [Ren.StatementType.ASK, Ren.StatementType.MENU]:
		dialog_text.bbcode_text += Ren.text_passer("{nl}{b}Your answer: ")
	
	if type == Ren.StatementType.ASK:
		dialog_text.bbcode_text += Ren.text_passer("{i}" + parameters.value + "{/i}{/b}")

	if type == Ren.StatementType.MENU:
		var fch = Ren.menu_node.choices_labels[parameters.final_choice]
		dialog_text.bbcode_text += Ren.text_passer("{i}" + fch + "{/i}{/b}")

func _on_visibility_changed() -> void:
	if not visible:
		return
	
	if temp_history == Ren.history:
		return
		
	var i = 0
	for hi_item in Ren.history:
		var type = hi_item.statement.type
		var parameters = hi_item.statement.parameters
		if i == get_child_count():
			add_history_item(type, parameters)
		
		elif temp_history[i] != Ren.history[i]:
			set_history_item(get_child(i), type, parameters)
		
		i += 1
		
	temp_history = Ren.history.duplicate()
		
