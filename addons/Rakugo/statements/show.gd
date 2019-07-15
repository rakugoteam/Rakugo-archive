extends Statement
class_name Show

var required = ["node_id", "state"]
var optional =  ["x", "y", "z", "at", "pos"]
onready var rnode := RakugoNodeCore.new()

func _init() -> void:
	._init()
	type = 4 # Rakugo.StatementType.SHOW
	parameters_names = required + optional


func exec() -> void:
	if not("state" in parameters):
		parameters["state"] = []

	var node_id = parameters.node_id

	if " " in node_id:
		var s = node_id.split(" ", false)
		parameters.node_id = s[0]
		s.remove(0)
		parameters.state = s

	var any_oparam = false
	for p in optional:
		if p in parameters.keys():
			any_oparam = true
			break

	if "at" in parameters:
		if "center" in parameters:
			parameters["x"] = 0.5
		if "left" in parameters:
			parameters["x"] = 0.0
		if "right" in parameters:
			parameters["x"] = 1.0
		if "center" in parameters:
			parameters["y"] = 0.5
		if "top" in parameters:
			parameters["y"] = 0.0
		if "bottom" in parameters:
			parameters["y"] = 1.0

	var p = parameters

	if not any_oparam:
		p = {}

	debug(parameters_names)
	Rakugo.on_show(parameters.node_id, parameters.state, p)
