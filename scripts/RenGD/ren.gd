## This is Ren'GD API ##

## version: 0.7 ##
## License MIT ##


extends Node

var vbc = "VBoxContainer"

## paths to nodes to use with special kinds of charcters
var adv_path	= "Adv/" + vbc
var cen_path	= "Center/" + vbc
var fs_path		= "FullScreen" + vbc

onready var input_screen	= get_node(adv_path + "/Input")
onready var say_screen		= get_node(adv_path)
onready var nvl_scroll		= get_node("Nvl")
onready var nvl_screen		= get_node("Nvl/" + vbc)
onready var dialog_manager	= get_node("DialogManager")
onready var choice_screen	= get_node("Choice")
onready var godot_con		= get_node("GodotConnect")

onready var say_scene = preload("res://scenes/gui/Say.tscn")

var snum = -1 ## current statement number it must start from -1
var seen_statements = []
var statements = []
var keywords = { "version":{"type":"text", "value":"0.7"} }
var nodes = {}
var can_roll = true

var important_types = ["say", "input", "menu"]

signal statement_changed

const REN_DEF = preload("ren_def.gd")
onready var ren_def = REN_DEF.new()

const REN_TXT = preload("ren_text.gd")
onready var ren_txt = REN_TXT.new()

const REN_TOOLS = preload("ren_tools.gd")
onready var ren_tls = REN_TOOLS.new()

const REN_NODES = preload("ren_nodes.gd")
onready var ren_nds = REN_NODES.new()


func _ready():
	## code borrow from:
	## http://docs.godotengine.org/en/stable/tutorials/step_by_step/singletons_autoload.html
	var root = get_tree().get_root()
	dialog_manager.current_scene = root.get_child( root.get_child_count() -1 )
	
	set_process_input(true)


func do_dialog():
	## This must be at end of ren's dialog
	next_statement()


func next_statement():
	## go to next statement
	use_statement(snum + 1)


func get_next_statement():
	## return next statement
	if snum + 1 <= statements.size() - 1:
		return statements[snum + 1]
	
	else:
		return {"type": "null", "arg": null}


func get_prev_statement():
	## return previous statement
	if snum - 1 >= 0:
		return statements[snum + 1]
	
	else:
		return {"type": "null", "arg": null}


func prev_statement():
	## go to previous statement
	var prev = seen_statements.find(statements[snum])
	prev = seen_statements[prev - 1]
	prev = statements.find(prev)
	use_statement(prev)


func jump_to_statement(statement):
	var id = statements.find(statement)
	use_statement(id)


func _input(event):

	if can_roll and snum > 0:
		if event.is_action_pressed("ren_rollforward"):
			next_statement()
		
		elif event.is_action_pressed("ren_rollback"):
			prev_statement()


func use_statement(num):
	## go to statement with given number
	print("using statement num: ", num)
	if num <= statements.size() - 1 and num >= 0:
		var s = statements[num]
		
		if s.type == "say":
			say(s)
		
		elif s.type == "input":
			input(s)
		
		elif s.type == "menu":
			menu(s)
		
		elif s.type == "show":
			s.arg.node.show()
		
		elif s.type == "hide":
			s.arg.node.hide()
		
		else:
			print("wrong type of statment")
			
		if num + 1 < statements.size():
			if not is_statement_id_important(num + 1):
				use_statement(num + 1)
		
		if is_statement_important(s):
			mark_seen(s)
		
		snum = num
		
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


func define(key_name, key_value = null):
	## add global var that ren will see
	ren_def.define(keywords, key_name, key_value)
	

func Character(name="", color ="", what_prefix="", what_suffix="", kind="adv"):
	## return new Character
	var ch = ren_def.Character(name, color, what_prefix, what_suffix, kind)
	return ch


func text_passer(text = ""):
	## passer for renpy markup format
	## its retrun bbcode
	return ren_txt.text_passer(keywords, text)


func dialog(dialog_name, scene_path, node_path = "", func_name = ""):
	## this declare new dialog
	## that make ren see dialog and can jump to it
	dialog_manager.dialog(dialog_name, scene_path, node_path, func_name)


func set_current_dialog(dialog):
	## this is need to be done in game first dialog
	dialog_manager.set_current_dialog(dialog)


func jump(dialog_name, args = []):
	## go to other declared dialog
	dialog_manager.jump(dialog_name, args)


func say_statement(how, what):
	## return input statement
	return say_screen.statement(how, what)


func append_say(how, what):
	## append say statement 
	var s = say_statement(how, what)
	statements.append(s)


func say(statement):
	## "run" say statement
	var how = statement.args.how

	# if how.kind == "adv":
	say_screen = get_node(adv_path)

	# if how in keywords:
	# 	if keywords[how].type == "Character":
	# 		var kind = keywords[how].value.kind
			
	# 		if kind == "center":
	# 			say_screen.hide()
	# 			get_node(fs_path).hide()
	# 			say_screen = get_node(cen_path)
			
	# 		elif kind == "fullscreen":
	# 			say_screen.hide()
	# 			get_node(cen_path).hide()
	# 			say_screen = get_node(fs_path)
			
	# 		elif kind == "nvl":
	# 			say_screen.hide()
	# 			get_node(fs_path).hide()
	# 			get_node(cen_path).hide()
	# 			say_screen = say_scene.instance()
	# 			nvl_screen.add_child(say_screen)
	# 			var y = say_screen.get_pos().y
	# 			nvl_scroll.set_v_scroll(y)
	# 			nvl_scroll.show()
	
	# 		if kind != "nvl":
	# 			var ipath = str(say_screen.get_path()) + "/Input"
	# 			input_screen = get_node(ipath)

	say_screen.use(statement)


func input_statement(ivar, what, temp = ""):
	## return input statement
	return input_screen.statement(ivar, what, temp)


func append_input(ivar, what, temp = ""):
	## append input statement
	var s = input_statement(ivar, what, temp)
	statements.append(s)


func array_slice(array, from = 0, to = 0):
	return ren_tls.array_slice(array, from, to)


func input(statement):
	## "run" input statement
	input_screen.use(statement)


func before_menu():
	## must be on begin of menu custom func
	choice_screen.before_menu()


func after_menu():
	## must be on end of menu custom func
	choice_screen.after_menu()


func menu_statement(choices, title = "", node = null, func_name = ""):
	## return custom menu statement
	## made to use menu statement easy to use with gdscript
	return choice_screen.statement(choices, title, node, func_name)


func append_menu(choices, title = "", node = null, func_name = ""):
	## append menu_func statement
	var s = menu_statement(choices, title, node, func_name)
	statements.append(s)


func menu(statement):
	## "run" menu statement
	choice_screen.use(statement)


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
	var s = show_statement(node_to_show)
	statements.append(s)


func hide_statement(node_to_hide):
	## return hide statement
	return ren_nds.hide_statement(nodes, node_to_hide)


func append_hide(node_to_hide):
	## append hide statment
	var s = hide_statement(node_to_hide)
	statements.append(s)

