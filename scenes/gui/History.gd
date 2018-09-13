extends VBoxContainer

export(PackedScene) var HistoryItemTemplate
onready var HistoryItem = load(HistoryItemTemplate.resource_path)
var temp_history = []

func _ready():
	connect("visibility_changed", self, "_on_visibility_changed")

func add_history_item(type, kwargs):
	var new_hi = HistoryItem.instance()
	set_history_item(new_hi, type, kwargs)
	add_child(new_hi)

func set_history_item(hi, type, kwargs):
	var label = hi.get_node("VBox/Label")
	var dialog_text = hi.get_node("VBox/Dialog")
	label.bbcode_text = ""
	dialog_text.bbcode_text = ""
	
	if "who" in kwargs:
		label.bbcode_text = kwargs.who

	if "what" in kwargs:
		dialog_text.bbcode_text = kwargs.what

	if type in ["ask", "menu"]:
		dialog_text.bbcode_text += Ren.text_passer("{nl}{b}Your answer: ")
	
	if type == "ask":
		dialog_text.bbcode_text += Ren.text_passer("{i}" + kwargs.value + "{/i}{/b}")

	if type == "menu":
		var fch = Ren.menu_node.choices_labels[kwargs.final_choice]
		dialog_text.bbcode_text += Ren.text_passer("{i}" + fch + "{/i}{/b}")

func _on_visibility_changed():
	if not visible:
		return
	
	if temp_history == Ren.history:
		return
		
	var i = 0
	for hi_item in Ren.history:
		var type = hi_item.statement.type
		var kwargs = hi_item.statement.kwargs
		if i == get_child_count():
			add_history_item(type, kwargs)
		
		elif temp_history[i] != Ren.history[i]:
			set_history_item(get_child(i), type, kwargs)
		
		i += 1
		
	temp_history = Ren.history.duplicate()
		
