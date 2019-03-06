extends Object
class_name Statement

var type : = 0 # Rakugo.StatementType.BASE
var parameters : = {"add_to_history": false} # dict of pairs keyword : argument
var parameters_names : = ["add_to_history"] # possible keywords for this type of statement - to use in RakugoScript in near future

func _ready() -> void:
	Rakugo.connect("exit_statement", self, "on_exit")

func exec() -> void:
	debug(parameters_names)
	
	Rakugo.current_statement = self
	Rakugo.exec_statement(type, parameters)

func set_parameters(new_parameters : Dictionary) -> void:
	# update statement
	set_dict(new_parameters, parameters)

func set_dict(new_dict : Dictionary, current_dict : Dictionary) -> void:
	for kw in new_dict:
		if kw != "":
			current_dict[kw] = new_dict[kw]

func setup_exit(_type : int, new_parameters : = {}) -> bool:
	if _type != type:
		return false
		
	if new_parameters != {}:
		set_parameters(new_parameters)
	
	return true

func on_exit(_type : int, new_parameters : = {}) -> void:
	if !setup_exit(_type, new_parameters):
		return
	
	if parameters.add_to_history:
		add_to_history()
	
	Rakugo.story_step()

func get_as_history_item() -> Dictionary:
	var hparameters = parameters.duplicate()
	hparameters.erase("avatar")
	var history_item = {
		"state": Rakugo.story_state,
		"statement":{
			"type": type,
			"parameters": hparameters
		}
	}
	return history_item


func add_to_history() -> void:
	if Rakugo.history_id < 0 or Rakugo.history_id > Rakugo.history.size() + 1:
		Rakugo.debug(["some thing gone wrong Rakugo.history_id =", Rakugo.history_id])
		Rakugo.debug(["history size:", Rakugo.history.size()])
		return
	
	var history_item = get_as_history_item()

	if Rakugo.history_id == Rakugo.history.size():
		Rakugo.history.append(history_item)

	else:
		Rakugo.history[Rakugo.history_id] = history_item
	
	if !(history_item in Rakugo.global_history):
		Rakugo.global_history.append(history_item)
	
	Rakugo.history_id += 1

func debug(parameters_names : Array = [], some_custom_text : String = "") -> void:
	var dbg = (Rakugo.StatementType.keys()[type].to_lower() + "("
			+ Rakugo.debug_dict(parameters, parameters_names, some_custom_text) + ")")
	Rakugo.debug(dbg)