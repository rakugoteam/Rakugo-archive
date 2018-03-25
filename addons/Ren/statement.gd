extends Node

var type = "base"
var kwargs = {} # dict of pairs keyword : argument
var org_kwargs = {} # org version of kwargs 
var kws = [] # possible keywords for this type of statement

func enter(dbg = true):
	if dbg:
		print(debug(kws))
	
	Ren.current_statement = self
	
	Ren.connect("exit_statement", self, "on_exit")
	# Ren.connect("enter_block", self, "on_enter_block")
	Ren.emit_signal("enter_statement", get_index(), type, kwargs)
	
	var new_kwargs = yield(Ren, "exit_statement")
	on_exit(new_kwargs)


func set_kwargs(new_kwargs):
	# update statement
	set_dict(new_kwargs, [kwargs, org_kwargs])

func set_dict(new_dict, dicts_array):
	for dict in dicts_array:
		for kw in new_dict:
			dict[kw] = new_dict[kw]
	
func on_enter_block(new_kwargs = {}):
	if new_kwargs != {}:
		set_kwargs(new_kwargs)
	
	if Ren.is_connected("enter_block", self, "on_enter_block"):
		Ren.disconnect("enter_block", self, "on_enter_block")

func on_exit(new_kwargs = {}):
	if new_kwargs != {}:
		set_kwargs(new_kwargs)
	
	if Ren.is_connected("exit_statement", self, "on_exit"):
		Ren.disconnect("exit_statement", self, "on_exit")

	# var next_sid = find_next()
	# if next_sid > -1:
	# 	enter_next(next_sid)
		
	# elif get_parent().has_method("on_exit"):
	# 	get_parent().on_exit(new_kwargs)
	
	# else:
	# 	print("End of Label")

func enter_next(next_sid):
	get_parent().get_child(next_sid).enter()

func find_next(start = get_index()):
	var next_sid = -1
	
	if start + 1 < get_parent().get_child_count():
		next_sid = start + 1

	return next_sid

func debug(kws = [], some_custom_text = ""):
	var dbg = ""
	
	for k in kws:
		if k in kwargs:
			dbg += k + " : " + str(kwargs[k]) + ", "
	
	if kws.size() > 0:
		dbg.erase(dbg.length() - 2, 2)

	dbg = str(get_index()) + ":" + type + "(" + some_custom_text + dbg + ")"
	return dbg