## This is Ren'GD API ##

## version: 0.7 ##
## License MIT ##

extends VBoxContainer

onready var ren = get_node("/root/Window")
onready var chbutton = preload("res://scenes/gui/ChoiceButton.tscn")

var choices = {} # {"choice":statement = []}
var title = ""
var node
var func_name = ""

var statements_before_menu = []
var statements_after_menu = []


func statement(choices, title, node = null, func_name = ""):
	## return menu statement
	var s = {
		"type": "menu",
		"args":
			{
			"title": title,
			"choices": choices,
			"node": node,
			"func_name": func_name
			}
	}

	return s


func append(choices, title = "", node = null, func_name = ""):
	## append menu statement
	var s = statement(choices, title, node, func_name)
	ren.statements.append(s)


func _use(choices, title, node, func_name):
	## "run" custom menu statement
	## made to use menu statement easy to use with gdscript
	ren.can_roll = false
	
	for ch in get_children():
		ch.free()

	if title != "":
		var s = ren.say_statement("", title)
		ren.say(s)
	
	else:
		ren.say_screen.hide()
	
	for k in choices:
		var b = chbutton.instance()
		
		add_child(b)

		k = "{center}" + k + "{/center}"
		k = ren.text_passer(k)

		var tr = b.get_child(0)
		tr.set_bbcode(k)

		b.connect("pressed", node, func_name, [b.get_index()])
	
	show()


func use(statement):
	## "run" custom menu statement
	choices = statement.args.choices
	title = statement.args.title

	if typeof(choices) == TYPE_DICTIONARY:
		_use(choices.keys(), title, self, "_on_choice")
	
	elif typeof(choices) == TYPE_ARRAY:
		node = statement.args.node
		func_name = statement.args.func_name
		_use(choices, title, node, func_name)


func before_menu():
	## must be on begin of menu custom func
	statements_before_menu = ren.array_slice(ren.statements, 0, ren.snum+1)
	statements_after_menu = ren.array_slice(ren.statements, ren.snum+1, ren.statements.size()+1)
	ren.statements = statements_before_menu


func after_menu():
	## must be on end of menu custom func
	ren.statements += statements_after_menu
	hide()
	ren.can_roll = true
	ren.next_statement()


func _on_choice(i):
	before_menu()
	ren.statements += choices.values()[i]
	after_menu()
	




