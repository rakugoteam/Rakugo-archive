extends VBoxContainer

export var choice_button:PackedScene = null

onready var expression = Expression.new()

func _ready():
	purge_childs()
	Rakugo.connect("menu", self, "build")


func _restore(_store):
	purge_childs()

func on_choice_button_pressed(_choice_button):
	var return_value = _choice_button.get_meta('return_value')
	purge_childs()
	Rakugo.menu_return(return_value)


func build(choices:Array, parameters:Dictionary):
	purge_childs()
	for i in choices.size():
		if _is_entry_visible(choices[i]):
			var button = choice_button.instance()
			button.set_meta("entry_number", i)
			button.set_meta("return_value", choices[i][1])
			button.set_meta("parameters", _apply_default(choices[i][2], parameters))
			button.text = choices[i][0]
			self.add_child(button)
			button.connect("choice_button_pressed", self, "on_choice_button_pressed")


func purge_childs():
	for c in self.get_children():
		self.call_deferred('remove_child', c)


func _is_entry_visible(entry):
	if not entry[2]:
		return true
	if entry[2].has('visible'):
		if entry[2]['visible'] is bool:
			return entry[2]['visible']
		elif entry[2]['visible']:
			push_warning("The the choice button parameter 'visible' expects a bool.")
	return false


func _apply_default(input:Dictionary, default:Dictionary):
	var output = input.duplicate()
	for k in default.keys():
		if not output.has(k):
			output[k] = default[k]
	return output
