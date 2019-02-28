extends Statement
class_name Show

func _init() -> void:
	._init()
	type = 4 # Rakugo.StatementType.SHOW
	parameters_names = ["node_id", "state", "x", "y", "z", "at", "pos"]

func exec() -> void:
	debug(parameters_names)
	
	if "at" in parameters:
		if "center" in parameters.at:
			parameters["x"] = 0.5
			
		if "left" in parameters.at:
			parameters["x"] = 0.0

		if "right" in parameters.at:
			parameters["x"] = 1.0

	if "at" in parameters:
		if "center" in parameters.at:
			parameters["y"] = 0.5
			
		if "top" in parameters.at:
			parameters["y"] = 0.0

		if "bottom" in parameters.at:
			parameters["y"] = 1.0
	
	Rakugo.on_show(parameters.node_id, parameters.state, parameters)
