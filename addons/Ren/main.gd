extends Node

var statements = []
var history = []
# Visual save/load
var history_vis=[]
var mainscriptnode
var vis_loading=false
var load_counter=0
var vnl=[]
# 
var history_id = 0
var rolling_back = false
var current_statement = null
var current_statement_id = -1
var current_local_statement_id = -1
var current_block
var current_menu
var choice_id = -1
var values = {
	"version":{"type":"text", "value":"0.5.0"},
	"test_bool":{"type":"var", "value":false},
	"test_float":{"type":"var", "value":10}
	}
var using_passer = false
export(bool) var debug_inti = true

const _DEF	= preload("def.gd")
const _CHR	= preload("character.gd")
const _SAY	= preload("say_statement.gd")
const _INP	= preload("input_statement.gd")
const _JMP	= preload("jump_statement.gd")
const _MENU	= preload("menu_statement.gd")
const _CHO	= preload("choice_statement.gd")
const _IF	= preload("if_statement.gd")
const _ELIF	= preload("elif_statement.gd")
const _ELSE	= preload("else_statement.gd")
const _GL	= preload("gd_statement.gd")
const _GB	= preload("godot_statement.gd")
const _SH	= preload("show_statement.gd")
const _HI	= preload("hide_statement.gd")
const _NO	= preload("notify_statement.gd")
const _GD	= preload("gd_connect.gd")
const _TXT	= preload("text.gd")

var godot = _GD.new()
var ren_text = _TXT.new()
var _def = _DEF.new()

signal enter_statement(id, type, kwargs)
signal enter_block(kwargs)
signal exit_statement(kwargs)
signal notified()
signal on_show(node_id, state, show_args)
signal on_hide(node_id)
signal val_changed(val_name)

func text_passer(text):
	if ren_text == null:
		ren_text = _TXT.new()
	return ren_text.text_passer(text, values)

# add/overwrite global value that Ren will see
func define(val_name, value = null):
	_def.define(values, val_name, value)
	emit_signal("val_changed", val_name)

# add/overwrite global value, from string, that Ren will see
func define_from_str(val_name, val_str, val_type):
	_def.define_from_str(values, val_name, val_str, val_type)
	emit_signal("val_changed", val_name)

# to use with `define_from_str` func as val_type arg
func get_type(val):
	return _def.get_type(val)

# returns value defined using define
func get_value(val_name):
	return values[val_name].value

# returns type of value defined using define
func get_value_type(val_name):
	return values[val_name].type
	
# crate new charater as global value that Ren will see
# possible kwargs: name, color, what_prefix, what_suffix, kind, avatar
func character(val_name, kwargs, node = null):
	# it always adds node to Ren
#	if node == null:
#		node = _CHR.new()
#		add_child(node)
	
	node.set_kwargs(kwargs)
	_def.define(values, val_name, node, "character")

# crate new link to node as global value that Ren will see
func node_link(node, node_id = node.name):
	if typeof(node) == TYPE_NODE_PATH:
		_def.define(values, node_id, node)
		
	elif node is Node:
		_def.define(values, node_id, node, "node")

func _init_statement(statement, kwargs, condition_statement = null):
	# statement.Ren = self
	statement.set_kwargs(kwargs)
	
	if debug_inti:
		statement.debug(statement.kws, "condition_statement: " + str(condition_statement) + ", ")
		
	if condition_statement != null:
		condition_statement.add_child(statement)
	
	else:
		add_child(statement)
	

	return statement

## create statement of type say
## its make given character(who) talk (what)
## with keywords : who, what
func say(kwargs, condition_statement = null):
	if not ("who" in kwargs):
		kwargs["who"] = ""
	return _init_statement(_SAY.new(), kwargs, condition_statement)

## crate statement of type input
## its allow player to provide keybord input that will be assain to given value
## with keywords : who, what, input_value, value
func input(kwargs, condition_statement = null):
	if not ("who" in kwargs):
		kwargs["who"] = ""
	return _init_statement(_INP.new(), kwargs, condition_statement)

## crate statement of type menu
## its allow player to make choice
## with keywords : who, what, title
func menu(kwargs, condition_statement = null):
	var title = null
	if "title" in kwargs:
		title = kwargs.title
		kwargs.erase("title")

	return _init_statement(_MENU.new(title), kwargs, condition_statement)

## crate statement of type choice
## its add this choice to menu
## with keywords : who, what
func choice(kwargs, menu):
	return _init_statement(_CHO.new(), kwargs, menu)

## create statement of type jump
## with keywords : dialog, statement_id
func jump(kwargs, condition_statement = null):
	return _init_statement(_JMP.new(), kwargs, condition_statement)

## create statement of type if
func if_statement(condition, condition_statement = null):
	return _init_statement(_IF.new(condition), {}, condition_statement)

## create statement of type elif
func elif_statement(condition, condition_statement = null):
	return _init_statement(_ELIF.new(condition), {}, condition_statement)

## create statement of type else
func else_statement(condition_statement = null):
	return _init_statement(_ELSE.new(), {}, condition_statement)

## create statement of type gd
## its execute godot one line code
func gd(code, condition_statement = null):
	return _init_statement(_GL.new(code), {}, condition_statement)

## create statement of type godot
## its execute block of godot code
func gd_block(code_block, condition_statement = null):
	return _init_statement(_GB.new(code_block), {}, condition_statement)

## create statement of type show
## with keywords : x, y, z, at, pos, camera
## x, y and pos will use it as procent of screen if between 0 and 1
## "at" is lists that can have: "top", "center", "bottom", "right", "left"
func show(node_id, state, kwargs, condition_statement = null):
	if not ("at" in kwargs):
		kwargs["at"] = ["center", "bottom"]
	return _init_statement(_SH.new(node_id, state), kwargs, condition_statement)

## create statement of type hide
func hide(node_id, condition_statement = null):
	return _init_statement(_HI.new(node_id), {}, condition_statement)

## create statement of type notify
func notifiy(info,length=5, conition_statement = null):
	return _init_statement(_NO.new(), {"info": info,"length":length}, conition_statement)


## it starts current Ren dialog
func start():
	current_block = []
	current_menu = []
	history_id = 1
	using_passer = false
	get_child(0).enter()
#	statements[0].enter()
	set_meta("playing",true) # for checking if Ren is playing


## go back to pervious statement that type is say, input or menu 
func rollback():
	if has_meta("usingvis"):
		set_meta("go_back",true)

		if statements[statements.size()-1].type=="menu":
			emit_signal("enter_block")
		else:
			emit_signal("exit_statement")

		set_meta("go_back",false)
		
	if not history.empty() and !has_meta("usingvis"):
		
		if rolling_back:
			history_id += 1

		else:
			rolling_back = true

		var previous = history[history.size() - history_id]
		
		while previous == current_statement:
			history_id += 1
			previous = history[history.size() - history_id]

		if is_connected("enter_block", previous, "on_enter_block"):
			disconnect("enter_block", previous, "on_enter_block")
		
		if is_connected("exit_statement", previous, "on_exit"):
			disconnect("exit_statement", previous, "on_exit")

		if is_connected("enter_block", current_statement, "on_enter_block"):
			disconnect("enter_block", current_statement, "on_enter_block")
		
		if is_connected("exit_statement", current_statement, "on_exit"):
			disconnect("exit_statement", current_statement, "on_exit")

		previous.enter()
		
		
func savefile(filepath="user://save.dat", password="Ren"):
	if has_meta("usingvis"):
		var tmpvalues={}
		for x in values:
			tmpvalues[x]=var2str(values[x])
		var savedict={
		"visual_history":history_vis,
		"values":tmpvalues,
		"mainscriptnode":mainscriptnode.get_path()
		}
		#config.set_value("main","statements",statements)
		#config.set_value("main","current_statement",current_statement_id)
		var file=File.new()
		if file.open_encrypted_with_pass(filepath,File.WRITE,password)==OK:
			file.store_line(to_json(savedict))
			file.close()
			return true
		else:
			return false
	
func loadfile(filepath="user://save.dat", password="Ren"):
	if has_meta("usingvis"):
		var file=File.new()
		if file.open_encrypted_with_pass(filepath,File.READ,password)==OK:
			var load_dict=parse_json(file.get_line())
			quitcurvis()
			vis_loading=true
			current_block = []
			current_menu = []
			current_statement_id=-1
			choice_id = -1
			using_passer = false
			statements=[]
			history_vis=load_dict["visual_history"]
			values=load_dict["values"]
			for x in values:
				values[x]=str2var(values[x])
			mainscriptnode=get_node(load_dict["mainscriptnode"])
			mainscriptnode.mainstory()
			vis_loading=false
			values=load_dict["values"]
			file.close()
			return true
		else:
			return false

func quitcurvis():
	set_meta("quitcurrent",true)
	print(history_vis)
	if statements[statements.size()-1].type=="menu":
		emit_signal("enter_block")
	else:
		emit_signal("exit_statement")
	set_meta("quitcurrent",false)

func can_skip():
	if not Ren.history.empty():
		if Ren.current_statement in Ren.history:
			if Ren.current_statement != Ren.history.back():
				return true
			
	return false

func debug(kwargs, kws = [], some_custom_text = ""):
	var dbg = ""
	
	for k in kws:
		if k in kwargs:
			if (k != null) or (k != ""):
				dbg += k + " : " + str(kwargs[k]) + ", "
	
	if kws.size() > 0:
		dbg.erase(dbg.length() - 2, 2)

	dbg = some_custom_text + dbg
	return dbg