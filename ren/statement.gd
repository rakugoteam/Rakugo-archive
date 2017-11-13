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
var ren # to attach node with main ren script (ren.gd)  needed to send singals 
var local = false 

func enter(dbg = true):
	if dbg:
		debug(kws)
		
	ren.current_statemnet_id = id
	ren.connect("exit_statement", self, "on_exit")
	ren.emit_signal("enter_statement", type, kwargs)

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

	ren.disconnect("exit_statement", self, "on_exit")
	var next_sid = find_next()
	if next_sid > -1:
		ren.statements[next_sid].enter()
		
	else:
		print("End of Label")

func find_next(start = id):
	var next_sid = -1

	var list_size = ren.statements.size()
	
	if start + 1 < list_size:
		next_sid = start + 1

	return next_sid

func debug(kws = [], some_custom_text = ""):
	var dbg = id + ":" + type + "(" + some_custom_text
	
	for k in kws:
		if k in kwargs:
			dbg += k + " : " + str(kwargs[k]) +", "
	
	if kws.size() > 0:
		dbg.erase( dbg.length() - 2,  2)

	dbg += ")"
	print(dbg)