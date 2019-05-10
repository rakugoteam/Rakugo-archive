extends Object
class_name Statement

var type : = 0 # Rakugo.StatementType.BASE
var parameters : = {"add_to_history": false} # dict of pairs keyword : argument
var parameters_names : = ["add_to_history"] # possible keywords for this type of statement - to use in RakugoScript in near future
var parameters_always := ["add_to_history"]

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
	for kw in current_dict.keys():
		if kw in parameters_always:
			continue

		if not (kw in new_dict):
			current_dict.erase(kw)

	for kw in new_dict.keys():
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

func get_history_id() -> Array:
	var id_list = [
		Rakugo.current_scene,
		Rakugo.current_node_name,
		Rakugo.current_dialog_name,
		Rakugo.story_state
	]

	var id = PoolStringArray(id_list).join(",")

	return id

func get_as_history_item() -> Dictionary:
	var hparameters = parameters.duplicate()
	hparameters.erase("avatar")
	var history_item = {
		"type": type,
		"parameters": hparameters
	}

	return history_item

func add_to_history() -> void:
	var id = get_history_id()
	var history_item = get_as_history_item()
	Rakugo.history[id] = history_item
	Rakugo.global_history[id] = history_item

	Rakugo.history_id += 1

func debug(parameters_names : Array = [], some_custom_text : String = "") -> void:
	var dbg = (Rakugo.StatementType.keys()[type].to_lower() + "("
			+ Rakugo.debug_dict(parameters, parameters_names, some_custom_text) + ")")
	Rakugo.debug(dbg)
