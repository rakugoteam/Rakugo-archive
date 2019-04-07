extends Statement
class_name CallNode

func _init() -> void:
	._init()
	type = 11 # Rakugo.StatementType.CALL_NODE
	parameters_names = ["node_id", "func_name", "args"]
	parameters["node_id"] = ""
	parameters["func_name"] = ""
	parameters["args"] = []

func exec() -> void:
	var node_path = Rakugo.get_value(parameters.node_id)["node_path"]
	var node = Rakugo.get_node(node_path)
	
	if !node:
		prints(parameters.node_id, "can't be find")
		return

	node.callv(parameters.func_name, parameters.args)
	.exec()
