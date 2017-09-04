## This is Ren'GD API ##

## version: 0.7 ##
## License MIT ##

extends Node

###					###
###	Dialogs system	###
###					###

onready var dialog_manager = get_node("DialogManager")

func _ready():
	## code borrow from:
	## http://docs.godotengine.org/en/stable/tutorials/step_by_step/singletons_autoload.html
	var root = get_tree().get_root()
	dialog_manager.current_scene = root.get_child( root.get_child_count() -1 )
	
	set_process_input(true)


func dialog(dialog_name, scene_path, node_path = "", func_name = ""):
	## this declare new dialog
	## that make ren see dialog and can jump to it
	dialog_manager.dialog(dialog_name, scene_path, node_path, func_name)


func set_current_dialog(dialog):
	## this is need to be done in game first dialog
	dialog_manager.set_current_dialog(dialog)


func jump_statement(dialog_name, args = []):
	## return jump statement
	return dialog_manager.statement(dialog_name, args)


func append_jump(dialog_name, args = []):
	## append jump statment
	var s = jump_statement(dialog_name, args)
	statements.append(s)	


func jump(statement):
	## go to other declared dialog
	dialog_manager.use(statement)

###						###
###	Statements system	###
###						###

var pnum = 0
var snum = -1 ## current statement number it must start from -1
var seen_statements = []
var statements = []
var can_roll = true
var important_types = ["say", "input", "menu"]

signal statement_changed

func do_dialog():
	## This must be at end of ren's dialog
	next_statement()


func add_statement(statement):
	statements.append(statement)


func next_statement():
	## go to next statement
	use_statement(snum + 1)


func get_next_statement(start_id = snum):
	## return next statement
	if start_id + 1 < statements.size():
		return statements[start_id + 1]
	
	else:
		return {"type": "null", "arg": null}


func get_prev_statement(start_id = snum):
	## return previous statement
	if start_id - 1 >= 0:
		return statements[start_id + 1]
	
	else:
		return {"type": "null", "arg": null}


func prev_statement():
	## go to previous statement
	use_statement(pnum)


func _input(event):

	if can_roll and snum > -1:
		if event.is_action_pressed("ren_rollforward"):
			next_statement()
		
		elif event.is_action_pressed("ren_rollback"):
			prev_statement()


func use_statement(num):
	## go to statement with given number
	print("try using statement num: ", num)
	if not can_roll:
		return

	if num < statements.size() and num > -1:
		var s = statements[num]
		
		if s.type == "say":
			say(s)
		
		elif s.type == "jump":
			jump(s)
		
		elif s.type == "input":
			ren_input(s)
		
		elif s.type == "menu":
			menu(s)
		
		elif s.type == "show":
			s.arg.node.show()
		
		elif s.type == "hide":
			s.arg.node.hide()
		
		elif s.type == "godot":
			g(s)
		
		elif s.type in ["if", "elif", "else", "end"]:
			 use_condition(s)
		
		else:
			print("wrong type of statment")
		
		if is_statement_important(s):
			mark_seen(s)
		
		else:
			use_statement(num + 1)
		
		snum = num
		print("used statement num: ", snum , " : ", s)
		emit_signal("statement_changed")


func mark_seen(statement):
	## add statement to save
	## and make statement skipable
	if statement in seen_statements:
		pass

	else:
		seen_statements.append(statement)


func was_seen_id(statement_id):
	## check if player seen statement with this id already
	if statement_id > -1 and statement_id < statements.size():
		return statements[statement_id] in seen_statements


func is_statement_id_important(statement_id):
	## return true if statement with this id is say, input or menu type
	return is_statement_important(statements[statement_id])


func is_statement_important(statement):
	## return true if statement is say, input or menu type
	var important = false
	  
	if statement.type in important_types:
		important = true
	
	return important


func was_seen(statement):
	## check if player seen this statement already
	return statement in seen_statements


func find_statement_of_type(statements_list, types):
	var i = -1
	for s in statements_list:
		if s.type in types:
			break

		i+=1
	
	return i

###						###
###	Define / Characters	###
###						###

const REN_DEF = preload("ren_def.gd")
onready var ren_def = REN_DEF.new()
var vars = { "version":{"type":"text", "value":"0.7"} }

func define(var_name, var_value = null):
	## add global var that ren will see
	ren_def.define(vars, var_name, var_value)
	

func Character(name="", color ="", what_prefix="", what_suffix="", kind="adv"):
	## return new Character
	var ch = ren_def.Character(name, color, what_prefix, what_suffix, kind)
	return ch


###					###
###	Text Passer		###
###					###

const REN_TXT = preload("ren_text.gd")
onready var ren_txt = REN_TXT.new()

func text_passer(text = ""):
	## passer for renpy markup format
	## its retrun bbcode
	return ren_txt.text_passer(vars, text)


###					###
###	Say statements	###
###					###

const REN_SAY = preload("ren_say.gd")
onready var ren_say = REN_SAY.new()

signal say(how, what, kind)


func say_statement(how, what):
	## return say statement
	return ren_say.statement(how, what)


func append_say(how, what):
	## append say statement 
	add_statement(say_statement(how, what))


func say(statement):
	## "run" say statement
	var how = statement.args.how

	var kind = "adv"
	
	if how in vars:
		if vars[how].type == "Character":
			var kind = vars[how].value.kind

	var args = ren_say.use(statement, vars)
	var how = text_passer(args[0])
	var what = text_passer(args[1])

	emit_signal("say", how, what, kind)


###						###
###	Input statements	###
###						###

const REN_INP = preload("ren_input.gd")
onready var ren_inp = REN_INP.new()

var input_var
signal ren_input(temp, what)

func ren_input_statement(ivar, what, temp = ""):
	## return input statement
	return ren_inp.statement(ivar, what, temp)


func append_ren_input(ivar, what, temp = ""):
	## append input statement
	add_statement(ren_input_statement(ivar, what, temp))


func ren_input(statement):
	## "run" input statement
	can_roll = false
	var args = ren_inp.use(statement)
	input_var = args.ivar
	var what = text_passer(args.what)
	var temp = text_passer(args.temp)
	emit_signal("ren_input", what, temp)


func set_ren_input_var(value):
	var type = "text"
	
	if value.is_valid_integer():
		value = int(value)
	
	elif value.is_valid_float():
		value = float(value)

	if typeof(value) != TYPE_STRING:
		type = "var"

	vars[input_var] = {"type":type, "value":value}
	can_roll = true
	next_statement()


###					###
###	Menu statements	###
###					###
const REN_CHO = preload("ren_choice.gd")
onready var ren_cho = REN_CHO.new()

var temp_choices
signal menu(choices, title, node, func_name)
signal after_menu


func after_menu():
	## must be on end of menu custom func
	#ren_cho.after_menu(statements)
	can_roll = true
	use_statement(statements.size() - 1)
	emit_signal("after_menu")


func menu_statement(choices, question = "", node = null, func_name = ""):
	## return custom menu statement
	## made to use menu statement easy to use with gdscript
	return ren_cho.statement(choices, question, node, func_name)


func append_menu(choices, question = "", node = null, func_name = ""):
	## append menu_func statement
	add_statement(menu_statement(choices, question, node, func_name))


func menu(statement):
	## "run" menu statement
	var args = ren_cho.use(statement)
	temp_choices = args.choices
	var choices = args.choices
	var func_name = args.func_name
	var node = args.node

	if typeof(choices) == TYPE_DICTIONARY:
		choices = choices.keys()
		func_name = "on_choice"
		node = self
	
	emit_signal ("menu", choices, args.question, node, func_name)


func on_choice(key):
	statements += temp_choices[key]
	after_menu()


func array_slice(array, from = 0, to = 0):
	if from > to or from < 0 or to > array.size():
		return array
	
	var _array = array

	for i in range(0, from):
		_array.remove(i)
	
	_array.resize(to - from)

	return _array


###								###
###	Node + show/hide statements	###
###								###

const REN_NODES = preload("ren_nodes.gd")
onready var ren_nds = REN_NODES.new()
var nodes = {}

func node(node_name, node_path, subnode = false):
	## asign a global ren name for given node
	ren_nds.node(nodes, node_name, node_path, subnode)


func auto_subnodes(node_name, node_path, name_of_node_to_skip = ""):
	## auto asign a global ren name for children of given node
	ren_nds.auto_subnodes(nodes, node_name, node_path, name_of_node_to_skip)
	

func show_statement(node_to_show):
	## return show statement
	return ren_nds.show_statement(nodes, node_to_show)


func append_show(node_to_show):
	## append show statment
	add_statement(show_statement(node_to_show))


func hide_statement(node_to_hide):
	## return hide statement
	return ren_nds.hide_statement(nodes, node_to_hide)


func append_hide(node_to_hide):
	## append hide statment
	add_statement(hide_statement(node_to_hide))


###										###
###	g:/godot: and conditions statements	###
###										###

onready var godot_con = get_node("GodotConnect")

func g_statement(expression):
	## return g/godot statement
	return godot_con.statement(expression)


func append_g(expression):
	## append g/godot statement
	add_statement(g_statement(expression))


func g(statement):
	## "run" g/godot statement
	godot_con.use(statement)


func if_statement(expression):
	## return if statment
	return godot_con.if_statement(expression)


func append_if(expression):
	## append if statement
	add_statement(if_statement(expression))


func elif_statement(expression):
	## return elif statment
	return godot_con.elif_statement(expression)


func append_elif(expression):
	## append if statement
	add_statement(elif_statement(expression))


func else_statement():
	## return else statment
	return godot_con.else_statement()


func append_else():
	## append if statement
	add_statement(else_statement())


func end_statement():
	## return end statment
	return godot_con.end_statement()


func append_end():
	## append if statement
	add_statement(end_statement())


func ren_condition(statement):
	## "run" condition statement
	godot_con.use_condition(statement, statements, snum)


