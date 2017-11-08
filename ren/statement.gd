## This is Ren API ##

## version: 0.2.0 ##
## License MIT ##

extends Node

###						###
###	Text Passer	import	###
###						###

const _TXT = preload("text.gd")
onready var _txt = _TXT.new()

func text_passer(text = ""):
	## passer for renpy markup format
	## its retrun bbcode
	if text == "" :
		return ""
	
	if _txt == null:
		_txt = _TXT.new()
	return _txt.text_passer(text, ren.values)

## version: 0.2.0 ##
## License MIT ##
## Base class for statement ##

var type = "base"
var id = 0 # postion of statment in ren.statements list
var kwargs = {} # dict of pairs keyword : argument
var org_kwargs = {} # org version of kwargs 
var kws = [] # possible keywords for this type of statement
var ren # to attach node with main ren script (main.gd) needed to send singals 
var indentation = 0 # number of tabs in indentation
var end_block = "none" # used only by end statement type

func _init():
	pass

func ren_init():
	check_indentation()

func check_indentation():
	if not ren.using_passer:
		indentation = ren.current_indentation
		return true

	if indentation != ren.current_indentation:
		print("wrong indentation " + debug(kws))
		return false

func enter(dbg = true, new_kwargs = {}):
	if not _init_enter(dbg, kwargs):
		return
	
	ren.connect("exit_statement", self, "on_exit")
	ren.emit_signal("enter_statement", type, kwargs)
	set_kwargs(org_kwargs)

func _init_enter(dbg = true, new_kwargs = {}):
	if new_kwargs != {}:
		set_kwargs(new_kwargs)

	if dbg:
		debug(kws)
	
	check_indentation()

	return true

func set_kwargs(new_kwargs):
	# update statement
	set_dict(new_kwargs, [kwargs, org_kwargs])

func set_dict(new_dict, dicts_array):
	for dict in dicts_array:
		for kw in new_dict:
			dict[kw] = new_dict[kw]

func on_exit(new_kwargs = {}):
	if new_kwargs != {}:
		set_kwargs(new_kwargs)
	
	if ren.is_connected("exit_statement", self, "on_exit"):
		ren.disconnect("exit_statement", self, "on_exit")

	var next_sid = find_next()
	if next_sid > -1:
		ren.statements[next_sid].enter()
	
	else:
		print("End of Label")

func find_next(start = id):
	var next_sid = -1
	
	if start + 1 < ren.statements.size():
		next_sid = start + 1

	return next_sid

func debug(kws = [], some_custom_text = ""):
	var dbg = type + "(" + some_custom_text
	
	for k in kws:
		if k in kwargs:
			dbg += k + " : " + str(kwargs[k]) +", "
	
	if kws.size() > 0:
		dbg.erase( dbg.length() - 2,  2)

	dbg += ")"
	print(dbg)