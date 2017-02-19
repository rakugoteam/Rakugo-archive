extends VButtonArray

onready var ren = get_node("/root/Window")
var choices = {} # {"choice":[statments]}
var title = ""
var _is_menu_on = false

func _ready():
	connect("button_selected", self, "_on_choice")


func _menu():
	ren.can_roll = false
	clear()

	if title != "":
		var s = {
				"how":"",
				"what":title,
				"format":true
				}
				
		ren._say(s)
		ren.say_screen.show()
	
	else:
		ren.say_screen.hide()

	
	for k in choices.keys():
		add_button(k)
	
	show()


func _on_choice(i):
	
	var statments_before_menu = array_slice(ren.statments, 0, ren.snum+1)
	var statments_after_menu = array_slice(ren.statments, ren.snum+1, ren.statments.size()+1)

	ren.statments = statments_before_menu
	ren.statments += choices.values()[i]
	ren.statments += statments_after_menu
	
	hide()
	ren.can_roll = true
	ren.next_statment()


func array_slice(array, from = 0, to = 0):
	if from > to or from < 0 or to > array.size():
		return array
	
	var _array = array

	for i in range(0, from):
		_array.remove(i)
    
	_array.resize(to - from)

	return _array


