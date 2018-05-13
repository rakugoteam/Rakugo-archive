extends Node

var type = "base"
var kwargs = {} # dict of pairs keyword : argument
var kws = [] # possible keywords for this type of statement

func _ready():
	Ren.connect("exit_statement", self, "on_exit")

func exec(dbg = true):
	if dbg:
		print(debug(kws))
	
	Ren.current_statement = self
	Ren.exec_statement(type, kwargs)

func set_kwargs(new_kwargs):
	# update statement
	set_dict(new_kwargs, kwargs)

func set_dict(new_dict, current_dict):
	for kw in new_dict:
		if kw != "":
			current_dict[kw] = new_dict[kw]

func setup_exit(_type, new_kwargs = {}):
	if _type != type:
		return false
		
	if new_kwargs != {}:
		set_kwargs(new_kwargs)
	
	return true

func on_exit(_type, new_kwargs = {}):
	if !setup_exit(_type, new_kwargs):
		return
	Ren.story_step()

func debug(kws = [], some_custom_text = ""):
	var dbg = type + "("
	dbg += Ren.debug(kwargs, kws, some_custom_text) + ")"
	return dbg