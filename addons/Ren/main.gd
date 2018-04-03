extends Node

var history = []
# Visual save/load
var history_vis=[]
var mainscriptnode
var vis_loading=false
var load_counter=0
var vnl=[]

var history_id = 0
var rolling_back = false
var current_statement = null

var current_menu
var current_id = 0

var values = {
	"version":{"type":"text", "value":"0.7.0 GDScript"},
	"test_bool":{"type":"var", "value":false},
	"test_float":{"type":"var", "value":10},
	"story_state":{"type":"text", "value":""}
	}

var using_passer = false
var dialogs = {} # "dialog_name":node
var current_dialog_name = ""

export(bool) var debug_inti = true

const _CHR	= preload("nodes/character.gd")
onready var timer = $Timer

# must be set on beging of dialog
var dialog_node setget _set_dialog_node, _get_dialog_node
var story_state setget _set_story_state, _get_story_state

signal exec_statement(type, kwargs)
signal enter_block(kwargs)
signal exit_statement(previous_type, kwargs)
signal notified()
signal show(node_id, state, show_args)
signal hide(node_id)
signal val_changed(val_name)
signal story_step(dialog_name)

func _ready():
	timer.connect("timeout", self, "exit_statement", [], CONNECT_PERSIST)

func exec_statement(id, type, kwargs = {}):
	emit_signal("exec_statement", id, type, kwargs)

func enter_block(kwargs = {}):
	emit_signal("enter_block", kwargs)

func exit_statement(kwargs = {}):
	emit_signal("exit_statement", current_statement.type, kwargs)

func story_step():
	emit_signal("story_step", current_dialog_name)

func notified():
	emit_signal("notified")

func on_show(node_id, state, show_args):
	emit_signal("show", node_id, state, show_args)

func on_hide(node):
	emit_signal("hide", node)

func val_changed(val_name):
	emit_signal("val_changed", val_name)

## parse text like in renpy to bbcode
func text_passer(text):
	return $Text.text_passer(text, values)

## add/overwrite global value that Ren will see
func define(val_name, value = null):
	$Def.define(values, val_name, value)
	val_changed(val_name)

## add/overwrite global value, from string, that Ren will see
func define_from_str(val_name, val_str, val_type):
	$Def.define_from_str(values, val_name, val_str, val_type)
	val_changed(val_name)

## to use with `define_from_str` func as val_type arg
func get_type(val):
	return $Def.get_type(val)

## returns value defined using define
func get_value(val_name):
	return values[val_name].value

## returns type of value defined using define
func get_value_type(val_name):
	return values[val_name].type
	
## crate new charater as global value that Ren will see
## possible kwargs: name, color, what_prefix, what_suffix, kind, avatar
func character(val_name, kwargs, node = null):
	# it always adds node to Ren
#	if node == null:
#		node = _CHR.new()
#		add_child(node)
	
	node.set_kwargs(kwargs)
	$Def.define(values, val_name, node, "character")

## crate new link to node as global value that Ren will see
func node_link(node, node_id = node.name):
	if typeof(node) == TYPE_NODE_PATH:
		$Def.define(values, node_id, node)
		
	elif node is Node:
		$Def.define(values, node_id, node, "node")

## add new dialog to which you can jump to
func add_dialog(node, dialog_name):
	if dialog_name in dialogs:
		print("there is already dialog named '", dialog_name, "'")
		return
	else:
		dialogs[dialog_name] = node

## statement of type say
## its make given character(who) talk (what)
## with keywords : who, what
func say(kwargs):
	if not ("who" in kwargs):
		kwargs["who"] = ""
	
	$Say.set_kwargs(kwargs)

	$Say.id = current_id
	current_id += 1
	$Say.exec()

## crate statement of type input
## its allow player to provide keybord input that will be assain to given value
## with keywords : who, what, input_value, value
func input(kwargs):
	if not ("who" in kwargs):
		kwargs["who"] = ""
	
	$Input.set_kwargs(kwargs)

	$Input.id = current_id
	current_id += 1
	$Input.exec()

## its allow player to make choice
## with keywords : who, what, choices, title
func menu(kwargs):
	var title = null
	if "title" in kwargs:
		title = kwargs.title
		kwargs.erase("title")
	
	if not ("who" in kwargs):
		kwargs["who"] = ""

	$Menu.set_kwargs(kwargs)
	
	$Menu.id = current_id
	current_id += 1
	$Menu.exec()


## it show custom ren node or charater
## 'state' arg is using to set for example current emtion or/and cloths
## 'state' example '['happy', 'green uniform']'
## with keywords : x, y, z, at, pos
## x, y and pos will use it as procent of screen if between 0 and 1
## "at" is lists that can have: "top", "center", "bottom", "right", "left"
func show(node_id, state = [], kwargs = {}):
	if not ("at" in kwargs):
		kwargs["at"] = ["center", "bottom"]

	kwargs["node_id"] = node_id
	kwargs["state"] = state
	
	print(kwargs)

	$Show.set_kwargs(kwargs)
	$Show.id = current_id
	current_id += 1
	$Show.exec()

## statement of type hide
func hide(node_id):
	var kwargs = {"node_id":node_id}
	$Hide.set_kwargs(kwargs)
	$Hide.id = current_id
	current_id += 1
	$Hide.exec()

## statement of type notify
func notifiy(info, length=5):
	var kwargs = {"info": info,"length":length}
	$Notify.set_kwargs(kwargs)
	$Notify.id = current_id
	current_id += 1
	$Notify.exec()

func _set_dialog_node(node):
	history_id = 1
	current_id = 0
	dialog_node = node

func _get_dialog_node():
	return dialog_node

func _set_story_state(state):
	define("story_state", state)

func _get_story_state():
	return get_value("story_state")

## it starts current Ren dialog
func start():
	current_menu = null
	using_passer = false
	set_meta("playing", true) # for checking if Ren is playing


## go back to pervious statement that type is say, input or menu 
func rollback():
	if has_meta("usingvis"):
		set_meta("go_back",true)

		if current_statement.type=="menu":
			enter_block()
		else:
			exit_statement()

		set_meta("go_back",false)
		
	if not history.empty() and !has_meta("usingvis"):
		
		if rolling_back:
			history_id += 1

		else:
			rolling_back = true

		var previous_state = history[history.size() - history_id]
		
		while previous_state == story_state:
			history_id += 1
			previous_state = history[history.size() - history_id]
		
		story_state = previous_state
		exit_statement()
		
		
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
			current_menu = null
			current_id=0
			using_passer = false
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
	if get_children().back().type=="menu":
		exec_statement()
	else:
		exit_statement()
	set_meta("quitcurrent",false)

func can_skip():
	if not Ren.history.empty():
		if Ren.history[0] != story_state:
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