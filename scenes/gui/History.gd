extends VBoxContainer

export(PackedScene) var HistoryItemTemplate
onready var HistoryItem = load(HistoryItemTemplate.resource_path)

func _ready():
	Ren.connect("exit_statement", self, "add_history_item", [], CONNECT_PERSIST)
	

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
		dialog_text.bbcode_text += Ren.text_passer("{i}" + kwargs.value + "{/i}{/b}")

	if type == "menu":
		var fch = Ren.current_menu.choices_labels[kwargs.final_choice]
		dialog_text.bbcode_text += Ren.text_passer("{i}" + fch + "{/i}{/b}")


		
	
	