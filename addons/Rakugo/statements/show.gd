extends Statement
class_name Show

var required = ["node_id", "state"]
var optional =  ["x", "y", "z", "at", "pos"]

func _init() -> void:
	._init()
	type = 4 # Rakugo.StatementType.SHOW
	parameters_names = required + optional

func exec() -> void:
	debug(parameters_names)

	if not("state" in parameters):
		parameters["state"] = []

	var any_oparam = false
	for p in optional:
		if p in parameters.keys():
			any_oparam = true
			break

	if !any_oparam:
		parameters["at"] = ["center", "bottom"]

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
