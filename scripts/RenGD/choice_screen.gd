extends VButtonArray

onready var ren = get_node("/root/Window")
var choices = {} # {"choice":[statments]}
var title = ""
var _is_menu_on = false

func _ready():
	connect("button_selected", self, "_on_choice")

func _menu():

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

	_is_menu_on = true
	for k in choices.keys():
		add_button(k)
	
	show()

func _on_choice(i):
	
	var statments_before_menu = ren.statments[0:snum]
	var statments_after_menu = ren.statments[snum+1:]

	ren.statments = statments_before_menu
	ren.statments += choices.values()[i]
	ren.statments += statments_after_menu
	
	hide()
	ren.next_statment()
	_is_menu_on = false
		



