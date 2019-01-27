extends Node
class_name Statement

var type : int = 0 # Ren.StatementType.BASE
var kwargs : Dictionary = {"add_to_history": false} # dict of pairs keyword : argument
var kws : Array = ["add_to_history"] # possible keywords for this type of statement - to use in RenScript in near future

func _ready() -> void:
	Ren.connect("exit_statement", self, "on_exit")

func exec(dbg: bool = true) -> void:
	if dbg:
		debug(kws)
	
	Ren.current_statement = self
	Ren.exec_statement(type, kwargs)

func set_kwargs(new_kwargs : Dictionary) -> void:
	# update statement
	set_dict(new_kwargs, kwargs)

func set_dict(new_dict : Dictionary, current_dict : Dictionary) -> void:
	for kw in new_dict:
		if kw != "":
			current_dict[kw] = new_dict[kw]

func setup_exit(_type : int, new_kwargs : Dictionary = {}) -> bool:
	if _type != type:
		return false
		
	if new_kwargs != {}:
		set_kwargs(new_kwargs)
	
	return true

func on_exit(_type : int, new_kwargs : Dictionary = {}) -> void:
	if !setup_exit(_type, new_kwargs):
		return
	
	if kwargs.add_to_history:
		add_to_history()
	
	Ren.story_step()

func get_as_history_item() -> Dictionary:
	var hkwargs = kwargs.duplicate()
	hkwargs.erase("avatar")
	var history_item = {
		"state": Ren.story_state,
		"statement":{
			"type": type,
			"kwargs": hkwargs
		}
	}
	return history_item


func add_to_history() -> void:
	if Ren.current_id < 0 or Ren.current_id > Ren.history.size() + 1:
		Ren.debug(["some thing gone wrong Ren.current_id =", Ren.current_id])
		Ren.debug(["history size:", Ren.history.size()])
		return
	
	var history_item = get_as_history_item()

	if Ren.current_id == Ren.history.size():
		Ren.history.append(history_item)

	else:
		Ren.history[Ren.current_id] = history_item
	
	if !(history_item in Ren.global_history):
		Ren.global_history.append(history_item)
		Ren.save_global_history()
	
	Ren.current_id += 1

func debug(kws : Array = [], some_custom_text : String = "") -> void:
	var dbg = Ren.StatementType.keys()[type].to_lower() + "("
	dbg += Ren.debug_dict(kwargs, kws, some_custom_text) + ")"
	Ren.debug(dbg)