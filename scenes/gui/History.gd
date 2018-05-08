extends VBoxContainer

export(PackedScene) var HistoryItemTemplate
onready var HistoryItem = load(HistoryItemTemplate.resource_path)

func _ready():
	connect("visibility_changed", self, "_on_visibility_changed", [], CONNECT_PERSIST)

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

	if type in ["input", "menu"]:
		dialog_text.bbcode_text += Ren.text_passer("{nl}{b}Your answer: ")
	
	if type == "input":
		dialog_text.bbcode_text += Ren.text_passer("{i}[" + kwargs.input_value + "]{/i}{/b}")

	if type == "menu":
		var fch = Ren.current_menu.choices_labels[kwargs.final_choice]
		dialog_text.bbcode_text += Ren.text_passer("{i}" + fch + "{/i}{/b}")


func _on_visibility_changed():
	if not visible:
		return
	
	var i = 0
	# print(Ren.history.values())
	for hi_item in Ren.history.values():
		print(hi_item)
		if not("statement" in hi_item):
			continue
		var s = hi_item["statement"]
		
		if i >= get_child_count():
			add_history_item(s.type, s.kwargs)

		else:
			var hi = get_child(i)
			set_history_item(hi, s.type, s.kwargs)
		
		i += 1
	
	