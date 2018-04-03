extends Node

var type = "base"
var kwargs = {} # dict of pairs keyword : argument
var org_kwargs = {} # org version of kwargs 
var kws = [] # possible keywords for this type of statement
var id = 0
var add_to_history = true
var previous_sate = ""

func _ready():
	Ren.connect("exit_statement", self, "on_exit", [], CONNECT_PERSIST)

func exec(dbg = true):
	if dbg:
		print(debug(kws))
	
	Ren.current_statement = self
	previous_sate = Ren.story_state
	Ren.exec_statement(id, type, kwargs)

func set_kwargs(new_kwargs):
	# update statement
	set_dict(new_kwargs, [kwargs, org_kwargs])

func set_dict(new_dict, dicts_array):
	for dict in dicts_array:
		for kw in new_dict:
			dict[kw] = new_dict[kw]
	

func on_exit(_type, new_kwargs = {}):
	if _type != type:
		return
		
	if new_kwargs != {}:
		set_kwargs(new_kwargs)
	
	if add_to_history:
		if not(previous_sate in Ren.history):
			if id < Ren.history.size():
				Ren.history[id] = previous_sate
			else:
				Ren.history.append(previous_sate)

	Ren.story_step()

func debug(kws = [], some_custom_text = ""):
	var dbg = str(get_index()) + ":" + type + "("
	dbg += Ren.debug(kwargs, kws, some_custom_text) + ")"
	return dbg