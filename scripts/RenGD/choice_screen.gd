## This is Ren'GD API ##
## Ren'GD is Ren'Py for Godot ##
## version: 0.6 ##
## License MIT ##

extends VBoxContainer

onready var ren = get_node("/root/Window")
onready var chbutton = preload("res://scenes/gui/ChoiceButton.tscn")
var choices = {} # {"choice":statement = []}
var title = ""


func _menu():
	ren.can_roll = false
	
	for ch in get_children():
		ch.disconnect("pressed", self, "_on_choice")
		ch.free()

	if title != "":
		var s = {
				"how":"",
				"what":title,
				}
				
		ren._say(s)
		ren.say_screen.show()
	
	else:
		ren.say_screen.hide()
	
	for k in choices.keys():
		var b = chbutton.instance()
		
		add_child(b)

		k = "{center}" + k + "{/center}"
		k = ren.say_passer(k)

		var tr = b.get_child(0)
		tr.set_bbcode(k)

		b.connect("pressed", self, "_on_choice", [b.get_index()])
	
	show()


func _on_choice(i):
	
	var statements_before_menu = array_slice(ren.statements, 0, ren.snum+1)
	var statements_after_menu = array_slice(ren.statements, ren.snum+1, ren.statements.size()+1)

	ren.statements = statements_before_menu
	ren.statements += choices.values()[i]
	ren.statements += statements_after_menu
	
	hide()
	ren.can_roll = true
	ren.next_statement()


func array_slice(array, from = 0, to = 0):
	if from > to or from < 0 or to > array.size():
		return array
	
	var _array = array

	for i in range(0, from):
		_array.remove(i)
    
	_array.resize(to - from)

	return _array


