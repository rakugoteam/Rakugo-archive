## This is Ren API ##

## version: 0.1.0 ##
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

## version: 0.1.0 ##
## License MIT ##
## Base class for statement ##

var type = "base"
var id = 0 # postion of statment in ren.statements list
var kwargs = {} # dict of pairs keyword : argument
				# they are passed from one statment to another
var kws = [] # possible keywords for this type of statement
var next_statement_types = [] # prefered types of next statement
var ren # to attach node with main ren script (ren.gd)  needed to send singals 

func use():
	debug(kws)
	ren.connect("next_statement", self, "next")
	ren.emit_signal("use_statement", type, id, kwargs)

func set_kwargs(new_kwargs):
	# update character
	for kw in new_kwargs:
		kwargs[kw] = new_kwargs[kw]
	
func next(id, new_kwargs = {}):
	if new_kwargs != {}:
		set_kwargs(new_kwargs)

	ren.disconnect("next_statement", self, "next")
	var next_sid = find_next(next_statement_types)
	if next_sid > -1:
		ren.statements[next_sid].use()

func find_next(types = []):
	var next_sid = -1
	
	if id + 1 < ren.statements.size():
		if types == []:
			next_sid = id + 1
		
		else:
			for i in range(id, ren.statements.size()):
				if ren.statements[i].type in types:
					next_sid = ren.statements[i].id
					break
	
		if next_sid == -1:
			next_sid = id + 1

	return next_sid

func debug(kws = []):
	var dbg = type + "("
	
	for k in kws:
		if k in kwargs:
			dbg += k + " : " + str(kwargs[k]) +", "
	
	dbg.erase( dbg.length() - 2,  2)

	dbg += ")"
	print(dbg)